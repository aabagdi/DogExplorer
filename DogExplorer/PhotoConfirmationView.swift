//
//  PhotoConfirmationView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import SwiftUI

struct PhotoConfirmationView<CameraModel: Camera>: View {
  @Binding var camera: CameraModel
    
    var body: some View {
      if let photoData = camera.returnPhoto() {
            if let image = UIImage(data: photoData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Failed to load image")
            }
        } else {
            ProgressView()
        }
    }
}
