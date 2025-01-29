//
//  CaptureActivity.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/25/25.
//

import Foundation

enum CaptureActivity {
  case idle
  case photoCapture(willCapture: Bool = false)
  
  var willCapture: Bool {
    if case .photoCapture(let willCapture) = self {
      return willCapture
    }
    return false
  }
}
