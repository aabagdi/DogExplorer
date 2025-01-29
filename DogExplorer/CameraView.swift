//
//  CameraView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import SwiftUI

struct CameraView<CameraModel: Camera>: View {
  @State var camera: CameraModel
  
  var body: some View {
    ZStack {
      CameraPreviewView(source: camera.previewSource)
        .edgesIgnoringSafeArea(.all)
      
      VStack {
        Spacer()
        ZStack {  // Use ZStack for true centering
          // Center button
          CameraButtonView(camera: camera)
          
          // Overlay switch camera at right edge
          HStack {
            Spacer()
            SwitchCameraButton(camera: camera)
              .padding(20)
          }
        }
        .padding(.bottom, 30)
      }
    }
    .background(Color.black)
    .task {
      await camera.start()
    }
  }
}
