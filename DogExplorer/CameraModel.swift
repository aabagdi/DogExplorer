//
//  CameraModel.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import Foundation
import SwiftUI
@preconcurrency import Combine
import OSLog

@Observable
class CameraModel: Camera {
  private(set) var status = CameraStatus.unknown
  
  private(set) var captureActivity = CaptureActivity.idle
  
  private(set) var isSwitchingVideoDevices = false
  
  private(set) var prefersMinimizedUI = false
  
  private(set) var shouldFlashScreen = false
  
  private(set) var thumbnail: CGImage?
  
  private(set) var error: Error?
  
  var previewSource: PreviewSource { captureManager.previewSource }
  
  private(set) var isHDRVideoSupported = false
  
  private let captureManager = CaptureManager()
  
  private var cameraState = CameraState()
  
  private var logger = Logger()
  
  var qualityPrioritization = QualityPrioritization.quality {
    didSet {
      cameraState.qualityPrioritization = qualityPrioritization
    }
  }
  
  var photo: Photo?
  
  init() {}
  
  func start() async {
    guard await captureManager.isAuthorized else {
      status = .unauthorized
      return
    }
    do {
      await syncState()
      try await captureManager.start()
      observeState()
      status = .running
    } catch {
      logger.error("Failed to start capture service. \(error)")
      status = .failed
    }
  }
  
  func switchVideoDevices() async {
    isSwitchingVideoDevices = true
    defer { isSwitchingVideoDevices = false }
    await captureManager.selectNextVideoDevice()
  }
  
  func focusAndExpose(at point: CGPoint) async {
    await captureManager.focusAndExpose(at: point)
  }
  
  func capturePhoto() async {
    do {
      let photo = try await captureManager.capturePhoto()
      self.photo = photo
      print(self.photo)
    } catch {
      self.error = error
    }
  }
  
  func clearPhoto() {
    photo = nil
  }
  
  func syncState() async {
    cameraState = await CameraState.current
    qualityPrioritization = cameraState.qualityPrioritization
  }
  
  private func observeState() {
    Task {
      for await activity in await captureManager.$captureActivity.values {
        if activity.willCapture {
          flashScreen()
        } else {
          captureActivity = activity
        }
      }
    }
    
    Task {
      for await isShowingFullscreenControls in await captureManager.$isShowingFullscreenControls.values {
        withAnimation {
          prefersMinimizedUI = isShowingFullscreenControls
        }
      }
    }
  }
  
  private func flashScreen() {
    shouldFlashScreen = true
    withAnimation(.linear(duration: 0.01)) {
      shouldFlashScreen = false
    }
  }
}
