//
//  CameraPreviewView.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/27/25.
//

import SwiftUI
@preconcurrency import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
  
  private let source: PreviewSource
  
  init(source: PreviewSource) {
    self.source = source
  }
  
  func makeUIView(context: Context) -> PreviewView {
    let preview = PreviewView()
    preview.previewLayer.videoGravity = .resizeAspectFill // Add this line
    source.connect(to: preview)
    return preview
  }
  
  func updateUIView(_ previewView: PreviewView, context: Context) {
    previewView.previewLayer.frame = previewView.bounds
  }
  
  class PreviewView: UIView, PreviewTarget {
    
    init() {
      super.init(frame: .zero)
      backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
      AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
      guard let previewLayer = layer as? AVCaptureVideoPreviewLayer else {
        fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check layerClass implementation.")
      }
      return previewLayer
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      previewLayer.frame = bounds
    }
    
    nonisolated func setSession(_ session: AVCaptureSession) {
      Task { @MainActor in
        previewLayer.session = session
      }
    }
  }
}

protocol PreviewSource: Sendable {
  func connect(to target: PreviewTarget)
}

protocol PreviewTarget {
  func setSession(_ session: AVCaptureSession)
}

struct DefaultPreviewSource: PreviewSource {
  
  private let session: AVCaptureSession
  
  init(session: AVCaptureSession) {
    self.session = session
  }
  
  func connect(to target: PreviewTarget) {
    target.setSession(session)
  }
}
