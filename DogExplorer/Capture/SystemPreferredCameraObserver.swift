//
//  SystemPreferredCameraObserver.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/27/25.
//

import Foundation
import AVFoundation

class SystemPreferredCameraObserver: NSObject {
  let changes: AsyncStream<AVCaptureDevice?>
  private var continuation: AsyncStream<AVCaptureDevice?>.Continuation?
  
  override init() {
    let (changes, continuation) = AsyncStream.makeStream(of: AVCaptureDevice?.self)
    self.changes = changes
    self.continuation = continuation
    
    super.init()
    
    AVCaptureDevice.addObserver(
      self,
      forKeyPath: "systemPreferredCamera",
      options: [.new],
      context: nil
    )
  }
  
  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey: Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    if keyPath == "systemPreferredCamera" {
      let newDevice = change?[.newKey] as? AVCaptureDevice
      continuation?.yield(newDevice)
    } else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
  }
  
  deinit {
    AVCaptureDevice.removeObserver(self, forKeyPath: "systemPreferredCamera")
    continuation?.finish()
  }
}
