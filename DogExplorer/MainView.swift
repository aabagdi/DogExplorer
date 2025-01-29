//
//  MainView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import SwiftUI
import PhotosUI

struct MainView: View {
  @State private var viewModel = MainViewModel()
  
  var body: some View {
    NavigationStack {
      VStack {
        Text("Welcome to Dog Explorer!")
        
        HStack {
          PhotosPicker(selection: $viewModel.photoPickerItem, matching: .images) {
            Label("Select a photo", systemImage: "photo")
          }
        }
        .tint(.blue)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .navigationDestination(item: $viewModel.selectedImage) { image in
          BreedView(photo: image)
        }
      }
    }
  }
}


#Preview {
  MainView()
}
