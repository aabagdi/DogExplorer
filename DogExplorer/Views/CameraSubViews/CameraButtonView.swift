//
//  CameraButtonView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import SwiftUI

struct CameraButtonView<CameraModel: Camera>: View {
  @State var camera: CameraModel
  
  @Binding var showPhotoConfirmation: Bool
  @Binding var isCapturing: Bool
  
  private let mainButtonDimension: CGFloat = 68
  
  var body: some View {
    PhotoCaptureButton(isDisabled: $isCapturing) {
      guard !isCapturing else { return }
      isCapturing = true
      await camera.capturePhoto()
      showPhotoConfirmation = true
    }
    .aspectRatio(1.0, contentMode: .fit)
    .frame(width: mainButtonDimension)
  }
}

private struct PhotoCaptureButton: View {
  private let action: () async -> Void
  private let lineWidth = CGFloat(4.0)
  @Binding var isDisabled: Bool
  
  init(isDisabled: Binding<Bool>, action: @escaping () async -> Void) {
    self._isDisabled = isDisabled
    self.action = action
  }
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: lineWidth)
        .fill(isDisabled ? .gray : .white)
      Button {
        Task {
          await action()
        }
      } label: {
        Circle()
          .inset(by: lineWidth * 1.2)
          .fill(isDisabled ? .gray : .white)
      }
      .buttonStyle(PhotoButtonStyle())
      .disabled(isDisabled)
    }
  }
  
  struct PhotoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
  }
}
