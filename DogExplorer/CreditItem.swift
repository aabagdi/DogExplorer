//
//  CreditItemView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/31/25.
//

import SwiftUI

struct CreditItem: View {
  let title: String
  let detail: String
  var link: String?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.headline)
      
      if let link = link {
        Link(detail, destination: URL(string: link)!)
          .foregroundColor(.blue)
      } else {
        Text(detail)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 5)
    )
  }
}
