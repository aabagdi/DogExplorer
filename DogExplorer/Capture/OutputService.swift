//
//  OutputService.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/25/25.
//

import Foundation
import AVFoundation

protocol OutputService {
  associatedtype Output: AVCaptureOutput
  var output: Output { get }
  var captureActivity: CaptureActivity { get }
  func updateConfiguration(for device: AVCaptureDevice)
  func setVideoRotationAngle(_ angle: CGFloat)
}

extension OutputService {
  func setVideoRotationAngle(_ angle: CGFloat) {
    output.connection(with: .video)?.videoRotationAngle = angle
  }
  func updateConfiguration(for device: AVCaptureDevice) {}
}
