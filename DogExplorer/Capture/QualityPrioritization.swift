//
//  QualityPrioritization.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/27/25.
//

import Foundation

enum QualityPrioritization: Int, Identifiable, CaseIterable, CustomStringConvertible, Codable {
  var id: Self { self }
  case speed = 1
  case balanced
  case quality
  var description: String {
    switch self {
    case.speed:
      return "Speed"
    case .balanced:
      return "Balanced"
    case .quality:
      return "Quality"
    }
  }
}
