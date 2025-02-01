//
//  SwitchCameraButtonView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import SwiftUI

struct SwitchCameraButton<CameraModel: Camera>: View {
  @State var camera: CameraModel
  
  var body: some View {
    Button {
      Task {
        await camera.switchVideoDevices()
      }
    } label: {
      Image(systemName: "arrow.triangle.2.circlepath")
        .foregroundColor(.white)
        .font(.system(size: 20))
        .frame(width: 64, height: 64)
        .contentShape(Rectangle())
    }
    .allowsHitTesting(!camera.isSwitchingVideoDevices)
  }
}
