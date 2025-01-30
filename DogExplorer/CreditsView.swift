//
//  SwiftUIView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/30/25.
//

import SwiftUI

struct CreditsView: View {
  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [.pink.opacity(0.2), .blue.opacity(0.2), .purple.opacity(0.2)]),
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing)
      .ignoresSafeArea()
      VStack {
        Text("Model trained on images from the Stanford Dogs Dataset by Aditya Khosla, Nityananda Jayadevaprakash, Bangpeng Yao and Li Fei-Fei, labeled dog dataset from images.cv and images of my Bichon Frise, Oskar")
          .padding()
        Text("Dog bark sound effect by crazymonke9 on Freesound.org")
          .padding()
      }
      .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  CreditsView()
}
