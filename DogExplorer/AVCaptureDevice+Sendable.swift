//
//  AVCaptureDevice+Sendable.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/27/25.
//

import Foundation
import AVFoundation

extension AVCaptureDevice: @retroactive @unchecked Sendable {}
