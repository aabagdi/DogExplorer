//
//  BreedView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/29/25.
//

import SwiftUI

struct BreedView<CameraModel: Camera>: View {
  @State var camera: CameraModel
  @State var viewModel = BreedViewModel()
  
  var body: some View {
    GeometryReader { g in
      VStack {
        if let photo = camera.returnPhoto() {
          if let image = UIImage(data: photo) {
            Image(uiImage: image)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .clipped()
              .ignoresSafeArea()
              .clipShape(RoundedRectangle(cornerRadius: 10))
          }
        }
        if let breed = viewModel.breed {
          Text("This dog is a \(breed)!")
        } else {
          ProgressView()
        }
      }
    }
    .onAppear {
      viewModel.identifyBreed(photo: camera.returnPhoto())
    }
  }
}
