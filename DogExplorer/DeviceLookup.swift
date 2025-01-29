//
//  DeviceLookup.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/27/25.
//

import Foundation
import AVFoundation

final class DeviceLookup {
  private let backCameraDiscoverySession: AVCaptureDevice.DiscoverySession
  private let frontCameraDiscoverySession: AVCaptureDevice.DiscoverySession
  
  init() {
    backCameraDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTripleCamera],
                                                                  mediaType: .video,
                                                                  position: .back)
    
    frontCameraDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInWideAngleCamera],
                                                                   mediaType: .video,
                                                                   position: .front)
    if AVCaptureDevice.systemPreferredCamera == nil {
      AVCaptureDevice.userPreferredCamera = backCameraDiscoverySession.devices.first
    }
  }
  
  var defaultCamera: AVCaptureDevice {
    get throws {
      guard let videoDevice = AVCaptureDevice.systemPreferredCamera else {
        throw CameraError.noDeviceFound
      }
      return videoDevice
    }
  }
  
  var cameras: [AVCaptureDevice] {
    var cameras = [AVCaptureDevice]()
    
    if let backCamera = backCameraDiscoverySession.devices.first {
      cameras.append(backCamera)
    }
    
    if let frontCamera = frontCameraDiscoverySession.devices.first {
      cameras.append(frontCamera)
    }
    return cameras
  }
}


