//
//  CameraManager.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/24/25.
//

import Foundation
import Combine
import OSLog
@preconcurrency import AVFoundation

actor CaptureManager {
  @Published private(set) var captureActivity: CaptureActivity = .idle
  @Published private(set) var isInterrupted = false
  @Published var isShowingFullscreenControls = false
  
  nonisolated let previewSource: PreviewSource
  
  private var isSetUp = false

  private let captureSession = AVCaptureSession()
  
  private let photoCapture = PhotoCapture()
  
  private var outputService: any OutputService { photoCapture }
  
  private var activeVideoInput: AVCaptureDeviceInput?
  
  private let deviceLookup = DeviceLookup()
  
  private let systemPreferredCamera = SystemPreferredCameraObserver()
  
  private var rotationCoordinator: AVCaptureDevice.RotationCoordinator!
  private var rotationObservers = [AnyObject]()
    
  private var delegate = CaptureControlsDelegate()
  
  private var controlsMap = [String: [AVCaptureControl]]()
    
  private let logger = Logger()
  
  init() {
    previewSource = DefaultPreviewSource(session: captureSession)
  }
  
  var isAuthorized: Bool {
    get async {
      let status = AVCaptureDevice.authorizationStatus(for: .video)
      var isAuthorized = status == .authorized
      if status == .notDetermined {
        isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
      }
      return isAuthorized
    }
  }
  
  func start() async throws {
    guard await isAuthorized, !captureSession.isRunning else { return }
    try setUpSession()
    captureSession.startRunning()
  }
  
  private func setUpSession() throws {
    guard !isSetUp else { return }
    
    observeOutputServices()
    observeNotifications()
    observeCaptureControlsState()
    
    do {
      let defaultCamera = try deviceLookup.defaultCamera
      
      activeVideoInput = try addInput(for: defaultCamera)
      try addOutput(photoCapture.output)
      
      createRotationCoordinator(for: defaultCamera)
      
      observeSubjectAreaChanges(of: defaultCamera)
      
      updateCaptureCapabilities()
      
      isSetUp = true
    } catch {
      throw CameraError.setUpFailed
    }
  }
  
  @discardableResult
  private func addInput(for device: AVCaptureDevice) throws -> AVCaptureDeviceInput {
    let input = try AVCaptureDeviceInput(device: device)
    
    if captureSession.canAddInput(input) {
      captureSession.addInput(input)
    } else {
      throw CameraError.cannotAddInput
    }
    return input
  }
  
  private func addOutput(_ output: AVCaptureOutput) throws {
    if captureSession.canAddOutput(output) {
      captureSession.addOutput(output)
    } else {
      throw CameraError.cannotAddOutput
    }
  }
  
  private var currentDevice: AVCaptureDevice {
    guard let device = activeVideoInput?.device else {
      fatalError("No device found for video output")
    }
    return device
  }
  
  func selectNextVideoDevice() {
    let videoDevices = deviceLookup.cameras
    
    let selectedIndex = videoDevices.firstIndex(of: currentDevice) ?? 0
    var nextIndex = selectedIndex + 1
    if nextIndex == videoDevices.endIndex {
      nextIndex = 0
    }
    
    let nextDevice = videoDevices[nextIndex]
    
    changeCaptureDevice(to: nextDevice)
    
    AVCaptureDevice.userPreferredCamera = nextDevice
  }
  
  private func changeCaptureDevice(to device: AVCaptureDevice) {
    guard let currentInput = activeVideoInput else { fatalError() }
    
    captureSession.beginConfiguration()
    defer { captureSession.commitConfiguration() }
    
    captureSession.removeInput(currentInput)
    do {
      activeVideoInput = try addInput(for: device)
      createRotationCoordinator(for: device)
      observeSubjectAreaChanges(of: device)
      updateCaptureCapabilities()
    } catch {
      captureSession.addInput(currentInput)
    }
  }
  
  private func createRotationCoordinator(for device: AVCaptureDevice) {
    rotationCoordinator = AVCaptureDevice.RotationCoordinator(device: device, previewLayer: videoPreviewLayer)
    
    updatePreviewRotation(rotationCoordinator.videoRotationAngleForHorizonLevelPreview)
    updateCaptureRotation(rotationCoordinator.videoRotationAngleForHorizonLevelCapture)
    
    rotationObservers.removeAll()
    
    rotationObservers.append(
      rotationCoordinator.observe(\.videoRotationAngleForHorizonLevelPreview, options: .new) { [weak self] _, change in
        guard let self, let angle = change.newValue else { return }
        Task { await self.updatePreviewRotation(angle) }
      }
    )
    
    rotationObservers.append(
      rotationCoordinator.observe(\.videoRotationAngleForHorizonLevelCapture, options: .new) { [weak self] _, change in
        guard let self, let angle = change.newValue else { return }
        Task { await self.updateCaptureRotation(angle) }
      }
    )
  }
  
  private func updatePreviewRotation(_ angle: CGFloat) {
    let previewLayer = videoPreviewLayer
    Task { @MainActor in
      previewLayer.connection?.videoRotationAngle = angle
    }
  }
  
  private func updateCaptureRotation(_ angle: CGFloat) {
    outputService.setVideoRotationAngle(angle)
  }
  
  private var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    guard let previewLayer = captureSession.connections.compactMap({ $0.videoPreviewLayer }).first else {
      fatalError("The app is misconfigured. The capture session should have a connection to a preview layer.")
    }
    return previewLayer
  }
  
  func focusAndExpose(at point: CGPoint) {
    let devicePoint = videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: point)
    do {
      try focusAndExpose(at: devicePoint, isUserInitiated: true)
    } catch {
      logger.debug("Unable to perform focus and exposure operation. \(error)")
    }
  }
  
  private func observeSubjectAreaChanges(of device: AVCaptureDevice) {
    subjectAreaChangeTask?.cancel()
    subjectAreaChangeTask = Task {
      for await _ in NotificationCenter.default.notifications(named: AVCaptureDevice.subjectAreaDidChangeNotification, object: device).compactMap({ _ in true }) {
        try? focusAndExpose(at: CGPoint(x: 0.5, y: 0.5), isUserInitiated: false)
      }
    }
  }
  
  private var subjectAreaChangeTask: Task<Void, Never>?
  
  private func focusAndExpose(at devicePoint: CGPoint, isUserInitiated: Bool) throws {
    let device = currentDevice
    
    try device.lockForConfiguration()
    
    let focusMode = isUserInitiated ? AVCaptureDevice.FocusMode.autoFocus : .continuousAutoFocus
    if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
      device.focusPointOfInterest = devicePoint
      device.focusMode = focusMode
    }
    
    let exposureMode = isUserInitiated ? AVCaptureDevice.ExposureMode.autoExpose : .continuousAutoExposure
    if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
      device.exposurePointOfInterest = devicePoint
      device.exposureMode = exposureMode
    }
    device.isSubjectAreaChangeMonitoringEnabled = isUserInitiated
    
    device.unlockForConfiguration()
  }

  func capturePhoto() async throws -> Data {
    try await photoCapture.capturePhoto()
  }
  
  private func updateCaptureCapabilities() {
    outputService.updateConfiguration(for: currentDevice)
  }
  
  private func observeOutputServices() {
    photoCapture.$captureActivity
      .assign(to: &$captureActivity)
  }
  
  private func observeCaptureControlsState() {
    delegate.$isShowingFullscreenControls
      .assign(to: &$isShowingFullscreenControls)
  }
  
  private func observeNotifications() {
    Task {
      for await reason in NotificationCenter.default.notifications(named: AVCaptureSession.wasInterruptedNotification)
        .compactMap({ $0.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject? })
        .compactMap({ AVCaptureSession.InterruptionReason(rawValue: $0.integerValue) }) {
        isInterrupted = [.videoDeviceInUseByAnotherClient].contains(reason)
      }
    }
    
    Task {
      for await _ in NotificationCenter.default.notifications(named: AVCaptureSession.interruptionEndedNotification) {
        isInterrupted = false
      }
    }
    
    Task {
      for await error in NotificationCenter.default.notifications(named: AVCaptureSession.runtimeErrorNotification)
        .compactMap({ $0.userInfo?[AVCaptureSessionErrorKey] as? AVError }) {
        if error.code == .mediaServicesWereReset {
          if !captureSession.isRunning {
            captureSession.startRunning()
          }
        }
      }
    }
  }
}

class CaptureControlsDelegate: NSObject, AVCaptureSessionControlsDelegate {
  
  @Published private(set) var isShowingFullscreenControls = false
  private let logger = Logger()
  
  func sessionControlsDidBecomeActive(_ session: AVCaptureSession) {
    logger.debug("Capture controls active.")
  }
  
  func sessionControlsWillEnterFullscreenAppearance(_ session: AVCaptureSession) {
    isShowingFullscreenControls = true
    logger.debug("Capture controls will enter fullscreen appearance.")
  }
  
  func sessionControlsWillExitFullscreenAppearance(_ session: AVCaptureSession) {
    isShowingFullscreenControls = false
    logger.debug("Capture controls will exit fullscreen appearance.")
  }
  
  func sessionControlsDidBecomeInactive(_ session: AVCaptureSession) {
    logger.debug("Capture controls inactive.")
  }
}
