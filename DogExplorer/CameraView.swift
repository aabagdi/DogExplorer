//
//  CameraView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import SwiftUI

struct CameraView<CameraModel: Camera>: View {
  @State var camera: CameraModel
  @State private var showPhotoConfirmation = false
  @State private var isCapturingPhoto = false
  
  var body: some View {
    ZStack {
      CameraPreviewView(source: camera.previewSource)
        .edgesIgnoringSafeArea(.all)
      VStack {
        Spacer()
        ZStack {
          CameraButtonView(camera: camera, showPhotoConfirmation: $showPhotoConfirmation, isCapturing: $isCapturingPhoto)
          HStack {
            Spacer()
            SwitchCameraButton(camera: camera)
              .padding(20)
          }
        }
        .padding(.bottom, 30)
      }
    }
    .task {
      await camera.start()
    }
    .fullScreenCover(isPresented: $showPhotoConfirmation) {
      NavigationStack {
        PhotoConfirmationView(camera: $camera, isPresented: $showPhotoConfirmation)
          .toolbar {
            ToolbarItem(placement: .topBarLeading) {
              Button("Retake") {
                showPhotoConfirmation = false
                isCapturingPhoto = false
                camera.clearPhoto()
              }
            }
            ToolbarItem(placement: .topBarTrailing) {
              NavigationLink(value: "Proceed") {
                Text("Proceed")
              }
              .navigationDestination(for: String.self) { _ in
                BreedView(camera: camera)
              }
            }
          }
          .interactiveDismissDisabled()
          .navigationBarBackButtonHidden(true)
          .toolbarBackground(.visible, for: .navigationBar)
      }
    }
  }
}
