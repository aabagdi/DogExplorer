//
//  PhotoCapture.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/25/25.
//

import Foundation
import AVFoundation
import CoreImage
import OSLog

final class PhotoCapture: OutputService {
  let output = AVCapturePhotoOutput()
  
  private var photoOutput: AVCapturePhotoOutput { output }
  
  @Published private(set) var captureActivity = CaptureActivity.idle
  
  func updateConfiguration(for device: AVCaptureDevice) {
    photoOutput.maxPhotoDimensions = device.activeFormat.supportedMaxPhotoDimensions.last ?? CMVideoDimensions()
    photoOutput.maxPhotoQualityPrioritization = .quality
  }
  
  func capturePhoto() async throws -> Photo {
    try await withCheckedThrowingContinuation { continuation in
      let delegate = PhotoCaptureDelegate(continuation: continuation)
      monitorProgress(of: delegate)
      let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
      photoOutput.capturePhoto(with: settings, delegate: delegate)
    }
  }
  
  
  private func monitorProgress(of delegate: PhotoCaptureDelegate, isolation: isolated (any Actor)? = #isolation) {
    Task {
      _ = isolation
      for await activity in delegate.activityStream {
        captureActivity = .photoCapture(willCapture: activity.willCapture)
      }
    }
  }
}

private class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
  private let continuation: CheckedContinuation<Photo, Error>
  private var isProxyPhoto = false
  private var photoData: Data?
  private let logger = Logger()
  
  let activityStream: AsyncStream<CaptureActivity>
  private let activityContinuation: AsyncStream<CaptureActivity>.Continuation
  
  init(continuation: CheckedContinuation<Photo, Error>) {
    self.continuation = continuation
    let (activityStream, activityContinuation) = AsyncStream.makeStream(of: CaptureActivity.self)
    self.activityStream = activityStream
    self.activityContinuation = activityContinuation
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    activityContinuation.yield(.photoCapture())
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    activityContinuation.yield(.photoCapture(willCapture: true))
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishCapturingDeferredPhotoProxy deferredPhotoProxy: AVCaptureDeferredPhotoProxy?, error: Error?) {
    if let error = error {
      logger.debug("Error capturing deferred photo: \(error)")
      return
    }
    photoData = deferredPhotoProxy?.fileDataRepresentation()
    isProxyPhoto = true
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let error = error {
      logger.debug("Error capturing photo: \(String(describing: error))")
      return
    }
    photoData = photo.fileDataRepresentation()
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
    defer {
      activityContinuation.finish()
    }
    
    if let error {
      continuation.resume(throwing: error)
      return
    }
    
    guard let photoData else {
      continuation.resume(throwing: PhotoError.noData)
      return
    }
    
    let photo = Photo(data: photoData, isProxy: isProxyPhoto)
    continuation.resume(returning: photo)
  }
}

extension PhotoCapture: @unchecked Sendable {}
