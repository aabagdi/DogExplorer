//
//  MainView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import SwiftUI
import PhotosUI

struct MainView: View {
  @State private var viewModel = MainViewModel()
  @State private var path = NavigationPath()
  @State private var camera = CameraModel()
  @State private var tapped = false
  private var bark = AudioPlayer()
  
  var body: some View {
    GeometryReader { geo in
      NavigationStack(path: $path) {
        ZStack {
          MainGradient()
          
          VStack {
            Spacer()
            
            VStack {
              HStack {
                LinearGradient(
                  colors: [.red, .purple, .pink, .blue],
                  startPoint: .leading,
                  endPoint: .trailing
                )
                .mask(
                  Text("DogExplorer!")
                    .font(Font.system(size: geo.size.width * 0.1144278607, weight: .bold))
                    .multilineTextAlignment(.center)
                )
              }
              Spacer()
              LinearGradient(
                colors: [.red, .purple, .pink, .blue],
                startPoint: .leading,
                endPoint: .trailing
              )
              .frame(minWidth: geo.size.width * 0.5, minHeight: geo.size.height * 0.5)
              .mask(
                Image(systemName: "dog.fill")
                  .font(.largeTitle)
                  .multilineTextAlignment(.center)
                  .foregroundStyle(.white)
                  .scaleEffect(tapped ? geo.size.width * 0.01529850746 : geo.size.width * 0.01243781095)
                  .animation(.spring(response: 0.35, dampingFraction: 0.15), value: tapped)
              )
              .onTapGesture {
                self.bark.play(sound: "Dog Bark")
                tapped.toggle()
                Task {
                  try await Task.sleep(nanoseconds: 200_000_000)
                  tapped.toggle()
                }
              }
            }
            .padding()
            
            Spacer()
            
            Button("Take a photo", systemImage: "camera") {
              path.append(NavigationDestination.camera)
            }
            .buttonStyle(GradientButtonStyle(colors: [.blue, .purple]))
            
            HStack {
              PhotosPicker(selection: $viewModel.photoPickerItem, matching: .images) {
                Label("Select a photo", systemImage: "photo")
              }
            }
            .buttonStyle(GradientButtonStyle(colors: [.purple, .pink]))
            .onChange(of: viewModel.photoPickerItem) { _, newItem in
              Task {
                await viewModel.setImage(from: newItem)
              }
            }
            .onChange(of: viewModel.selectedImage) { _, newImage in
              if let newImage {
                path.append(newImage)
              }
            }
            .navigationDestination(for: Data.self) { image in
              BreedView(photo: image, path: $path)
            }
            
            Button("Discovered breeds", systemImage: "dog") {
              path.append(NavigationDestination.breedList)
            }
            .buttonStyle(GradientButtonStyle(colors: [.pink, .orange]))
            
            Button("Credits", systemImage: "list.bullet") {
              path.append(NavigationDestination.credits)
            }
            .buttonStyle(GradientButtonStyle(colors: [.orange, .blue]))
            .navigationDestination(for: NavigationDestination.self) { destination in
              switch destination {
              case .camera:
                CameraView(camera: camera, path: $path)
              case .breedList:
                BreedListView()
              case .credits:
                CreditsView()
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  MainView()
}
