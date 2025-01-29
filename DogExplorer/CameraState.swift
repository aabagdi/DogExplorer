//
//  CameraState.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/27/25.
//

import Foundation
import os

struct CameraState: Codable {
    
    var isLivePhotoEnabled = true {
        didSet { save() }
    }
    
    var qualityPrioritization = QualityPrioritization.quality {
        didSet { save() }
    }
    
    private func save() {
        Task {
            do {
              try await DogExplorerCamCaptureIntent.updateAppContext(self)
            } catch {
                os.Logger().debug("Unable to update intent context: \(error.localizedDescription)")
            }
        }
    }
    
    static var current: CameraState {
        get async {
            do {
              if let context = try await DogExplorerCamCaptureIntent.appContext {
                    return context
                }
            } catch {
                os.Logger().debug("Unable to fetch intent context: \(error.localizedDescription)")
            }
            return CameraState()
        }
    }
}
