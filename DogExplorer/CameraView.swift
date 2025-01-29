//
//  CameraView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import SwiftUI

struct CameraView<CameraModel: Camera>: View {
  @State var camera: CameraModel
  //@State var isPresented = false
  
  var body: some View {
    ZStack {
      CameraPreviewView(source: camera.previewSource)
        .edgesIgnoringSafeArea(.all)
      
      VStack {
        Spacer()
        ZStack {
          CameraButtonView(camera: camera)
          HStack {
            Spacer()
            SwitchCameraButton(camera: camera)
              .padding(20)
          }
        }
        .padding(.bottom, 30)
      }
    }
    /*.onChange(of: camera.returnPhoto()) {
      isPresented.toggle()
    }*/
    .background(Color.black)
    /*.sheet(isPresented: $isPresented) {
      PhotoConfirmationView(camera: $camera)
    }*/
    .task {
      await camera.start()
    }
  }
}
