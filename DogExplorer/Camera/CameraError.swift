//
//  CameraError.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/24/25.
//

import Foundation

enum CameraError: Error {
  case noDeviceFound
  case cannotAddInput
  case cannotAddOutput
  case setUpFailed
  case createCaptureInput(Error)
  case deniedAuthorization
  case restrictedAuthorization
  case unknownAuthorization
}
