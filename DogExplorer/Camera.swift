//
//  Camera.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import Foundation
import SwiftUI

@MainActor
protocol Camera: AnyObject {
  var status: CameraStatus { get }
  
  var captureActivity: CaptureActivity { get }
  
  var previewSource: PreviewSource { get }
  
  func start() async
  
  var prefersMinimizedUI: Bool { get }
  
  func switchVideoDevices() async
  
  var isSwitchingVideoDevices: Bool { get }
  
  func focusAndExpose(at point: CGPoint) async
  
  var qualityPrioritization: QualityPrioritization { get set }
  
  func capturePhoto() async
  
  func clearPhoto()
  
  var shouldFlashScreen: Bool { get }
  
  var error: Error? { get }
  
  func syncState() async
}
