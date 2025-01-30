//
//  Routes.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/29/25.
//

import Foundation

enum Route: Hashable {
  case cameraView
  case mainView
  case breedView(photo: Data?)
}
