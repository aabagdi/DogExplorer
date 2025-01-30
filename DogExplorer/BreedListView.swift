//
//  BreedListView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/29/25.
//

import Foundation
import SwiftUI

struct BreedListView: View {
  @AppStorage("breedList") var breedListData: Data = Data()
  
  private var collectedBreeds: [String] {
    if let breeds = try? JSONDecoder().decode([String].self, from: breedListData) {
      return breeds.sorted()
    }
    return []
  }
  
  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [.pink.opacity(0.2), .blue.opacity(0.2), .purple.opacity(0.2)]),
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing)
      .ignoresSafeArea()
      VStack {
        List {
          if collectedBreeds.isEmpty {
            Text("No breeds discovered yet!")
              .foregroundColor(.secondary)
          } else {
            ForEach(collectedBreeds, id: \.self) { breed in
              HStack {
                Image(systemName: "dog")
                  .foregroundColor(.blue)
                Text(breed)
                  .font(.body)
              }
            }
          }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Discovered Breeds")
        .navigationBarTitleDisplayMode(.large)
        
        Text("\(collectedBreeds.count) breeds found out of 122")
          .font(.footnote)
      }
    }
  }
}
