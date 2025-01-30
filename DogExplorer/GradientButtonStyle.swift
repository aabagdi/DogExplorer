//
//  GradientButtonStyle.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/30/25.
//

import Foundation
import SwiftUI

struct GradientButtonStyle: ButtonStyle {
  let colors: [Color]
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, 30)
      .padding(.vertical, 15)
      .background(
        LinearGradient(
          colors: colors,
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .foregroundColor(.white)
      .font(.headline)
      .clipShape(RoundedRectangle(cornerRadius: 15))
      .shadow(radius: 5)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.spring(response: 0.3), value: configuration.isPressed)
  }
}
