//
//  BreedView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/29/25.
//

import SwiftUI

struct BreedView: View {
  @State var viewModel = BreedViewModel()
  var photo: Data?
  
  // MARK: - View States
  @State private var isImageLoading = false
  @State private var showRetryButton = false
  
  @Binding var path: NavigationPath
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        VStack(spacing: 20) {
          photoView
          breedInfoView
        }
        .padding()
        .frame(minHeight: geometry.size.height)
      }
    }
    .onAppear(perform: identifyBreed)
    .navigationBarBackButtonHidden(true)
  }
  
  // MARK: - Subviews
  
  private var photoView: some View {
    Group {
      if let photo,
         let image = UIImage(data: photo) {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .shadow(radius: 5)
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(Color.gray.opacity(0.2), lineWidth: 1)
          )
          .accessibilityLabel("Dog photo")
      } else {
        placeholderView
      }
    }
  }
  
  private var breedInfoView: some View {
    Group {
      if isImageLoading {
        ProgressView("Analyzing photo...")
          .progressViewStyle(CircularProgressViewStyle())
      } else if let breed = viewModel.breed {
        breedResultView(breed: breed)
      } else if let error = viewModel.error {
        errorView(error: error)
      }
    }
    .animation(.easeInOut, value: isImageLoading)
    .animation(.easeInOut, value: viewModel.breed)
    .animation(.easeInOut, value: viewModel.error?.localizedDescription)
  }
  
  private var placeholderView: some View {
    RoundedRectangle(cornerRadius: 16)
      .fill(Color.gray.opacity(0.1))
      .overlay(
        Image(systemName: "photo")
          .font(.largeTitle)
          .foregroundColor(.gray)
      )
      .frame(height: 300)
      .accessibilityLabel("No photo available")
  }
  
  private func breedResultView(breed: String) -> some View {
    VStack(spacing: 12) {
      Text("Breed Identified!")
        .font(.headline)
        .foregroundColor(.green)
      
      Text("This appears to be a \(breed)!")
        .font(.title2)
        .multilineTextAlignment(.center)
        .foregroundColor(.primary)
      
      Button("Return to main menu") {
        path = NavigationPath()
      }
      .buttonStyle(.bordered)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.gray.opacity(0.05))
    )
  }
  
  private func errorView(error: Error) -> some View {
    VStack(spacing: 12) {
      Text("Unable to Identify Breed")
        .font(.headline)
        .foregroundColor(.red)
      
      Text(error.localizedDescription)
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
      
      if showRetryButton {
        Button("Retry Analysis") {
          identifyBreed()
        }
        .buttonStyle(.bordered)
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.red.opacity(0.05))
    )
  }
  
  // MARK: - Actions
  
  private func identifyBreed() {
    guard let photo else { return }
    
    isImageLoading = true
    showRetryButton = false
    
    viewModel.identifyBreed(photo: photo)
    
    isImageLoading = false
  }
}

