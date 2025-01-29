//
//  DogExplorerCamCaptureIntent.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/28/25.
//

import Foundation
import AppIntents
import os

struct DogExplorerCamCaptureIntent: CameraCaptureIntent {

    typealias AppContext = CameraState
    
    static let title: LocalizedStringResource = "DogExplorerCamCaptureIntent"
    static let description: IntentDescription = IntentDescription("Identify dog breeds via the camera using Dog Explorer.")

    @MainActor
    func perform() async throws -> some IntentResult {
        os.Logger().debug("DogExplorer capture intent performed successfully.")
        return .result()
    }
}
