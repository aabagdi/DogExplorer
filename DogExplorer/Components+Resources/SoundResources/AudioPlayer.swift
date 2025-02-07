//
//  AudioPlayer.swift
//  Dog Explorer
//
//  Created by Aadit Bagdi on 2/16/23.
//

import AVFoundation

class AudioPlayer {
  private var audioPlayer = AVAudioPlayer()
  
  func play(sound: String) {
    guard let soundEffect = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
    guard let player =  try? AVAudioPlayer(contentsOf: soundEffect) else { return }
    self.audioPlayer = player
    self.audioPlayer.prepareToPlay()
    self.audioPlayer.play()
    try? AVAudioSession.sharedInstance().setCategory(.ambient)
    try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    
  }
}
