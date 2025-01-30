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
  @State private var path = NavigationPath()
  @State private var camera = CameraModel()
  
  var body: some View {
    NavigationStack(path: $path) {
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
        .onChange(of: viewModel.photoPickerItem) { _, newItem in
          Task {
            await viewModel.setImage(from: newItem)
          }
        }
        .onChange(of: viewModel.selectedImage) { _, newImage in
          if let newImage {
            path.append(newImage)
          }
        }
        .navigationDestination(for: Data.self) { image in
          BreedView(photo: image, path: $path)
        }
        
        Button("Take a photo", systemImage: "camera") {
          path.append(NavigationDestination.camera)
        }
        .tint(.blue)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        Button("Discovered breeds", systemImage: "dog") {
          path.append(NavigationDestination.breedList)
        }
        .tint(.blue)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        .navigationDestination(for: NavigationDestination.self) { destination in
          switch destination {
          case .camera:
            CameraView(camera: camera, path: $path)
          case .breedList:
            BreedListView()
          }
        }
      }
    }
  }
}

#Preview {
  MainView()
}
