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
                .ignoresSafeArea()
            
            // Controls overlay
            VStack {
                Spacer()
                
                // Bottom control bar
                HStack {
                    // Equal spacing on both sides
                    Spacer(minLength: 80)
                    
                    // Centered capture button
                    CameraButtonView(camera: camera)
                    
                    // Right side with switch camera
                    HStack {
                        Spacer(minLength: 80)
                        SwitchCameraButton(camera: camera)
                            .padding(.trailing, 20)
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
