//
//  MainGradient.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/31/25.
//

import SwiftUI

struct MainGradient: View {
  var body: some View {
    LinearGradient(gradient:
                    Gradient(colors: [
                      .pink.opacity(0.2),
                      .blue.opacity(0.2),
                      .purple.opacity(0.2)]),
                   startPoint: .topLeading, endPoint: .bottomTrailing)
    .ignoresSafeArea()
  }
}

#Preview {
  MainGradient()
}
