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
      MainGradient()
      ScrollView {
        VStack(spacing: 24) {
          // Header section
          Text("Training Data Sources")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top)
          
          // Dataset credits section
          VStack(alignment: .leading, spacing: 16) {
            CreditItem(
              title: "Stanford Dogs Dataset",
              detail: "by Aditya Khosla, Nityananda Jayadevaprakash, Bangpeng Yao and Li Fei-Fei"
            )
            
            CreditItem(
              title: "Labeled Dog Dataset",
              detail: "from images.cv"
            )
            
            CreditItem(
              title: "Personal Collection",
              detail: "Images of my Bichon Frise, Oskar"
            )
          }
          .padding(.horizontal)
          
          // Additional resources section
          VStack(spacing: 16) {
            Text("Additional Resources")
              .font(.title3)
              .fontWeight(.semibold)
            
            CreditItem(
              title: "Sound Effects",
              detail: "Dog bark sound effect by crazymonke9 on Freesound.org"
            )
            
            CreditItem(
              title: "App Icon",
              detail: "Developed with help from Sarang Pawar",
              link: "https://www.reddit.com/user/usernameisnotmine/"
            )
          }
          .padding(.horizontal)
        }
        .padding(.bottom)
      }
    }
    .navigationTitle("Resource Credits")
    .navigationBarTitleDisplayMode(.large)
  }
}

#Preview {
  NavigationView {
    CreditsView()
  }
}
