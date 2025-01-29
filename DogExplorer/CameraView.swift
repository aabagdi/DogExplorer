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
      // Full screen camera preview
      CameraPreviewView(source: camera.previewSource)
        .ignoresSafeArea(.all) // Explicitly ignore all safe areas
        .edgesIgnoringSafeArea(.all) // Belt and suspenders approach
      
      // Controls overlay
      VStack {
        Spacer()
        
        // Bottom control bar
        HStack {
          // Empty spacer for left side
          Spacer()
          
          // Centered capture button
          CameraButtonView(camera: camera)
          
          // Right side spacer and switch camera
          Spacer()
          
          SwitchCameraButton(camera: camera)
            .padding(.trailing, 20)
        }
        .padding(.bottom, 30)
      }
    }
    .edgesIgnoringSafeArea(.all) // Ensure the ZStack also ignores safe areas
    .background(Color.black)
    .task {
      await camera.start()
    }
  }
}
