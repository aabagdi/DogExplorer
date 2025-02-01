//
//  BreedViewModel.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/29/25.
//

import Foundation
import CoreML
import UIKit

@Observable
class BreedViewModel {
  var breed: String?
  var error: Error?
  
  func identifyBreed(photo: Data?) {
    do {
      let config = MLModelConfiguration()
      let model = try DogBreedClassifier(configuration: config)
      guard let photo,
            let image = UIImage(data: photo),
            let resized = image.resizeTo(size: CGSize(width: 360, height: 360)),
            let buffer = resized.toBuffer() else { return }
      
      let prediction = try model.prediction(image: buffer)
      self.breed = prediction.target
    } catch {
      self.error = error
    }
  }
}
