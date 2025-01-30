//
//  MainViewModel.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/29/25.
//

import Foundation
import _PhotosUI_SwiftUI

@Observable
@MainActor
class MainViewModel {
  var selectedImage: Data?
  var photoPickerItem: PhotosPickerItem?
  private var error: Error?
  
  func setImage(from selection: PhotosPickerItem?) async {
    guard let selection else { return }
    do {
      if let data = try await selection.loadTransferable(type: Data.self) {
        selectedImage = data
        return
      }
    } catch {
      self.error = error
    }
  }
}

