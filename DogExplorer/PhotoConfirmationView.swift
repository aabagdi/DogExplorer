//
//  PhotoConfirmationView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import SwiftUI

struct PhotoConfirmationView<CameraModel: Camera>: View {
  @Binding var camera: CameraModel
  @Binding var isPresented: Bool
  
  var body: some View {
    GeometryReader { geometry in
      if let photo = camera.returnPhoto() {
        if let image = UIImage(data: photo) {
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .ignoresSafeArea()
        } else {
          Text("Failed to load image")
        }
      } else {
        ProgressView()
      }
    }
    .ignoresSafeArea()
  }
}
