//
//  BreedListView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/29/25.
//

import Foundation
import CoreML
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
    .navigationTitle("Discovered Breeds")
    .navigationBarTitleDisplayMode(.large)
  }
}
