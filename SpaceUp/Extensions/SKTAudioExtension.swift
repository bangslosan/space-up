//
//  SKTAudioExtension.swift
//  SpaceUp
//
//  Created by David Chin on 5/07/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import AVFoundation

extension SKTAudio {
  func playBackgroundMusic(filename: String, volume: Float) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)

    if (url == nil) {
      print("Could not find file: \(filename)")
      return
    }
    
    var error: NSError? = nil

    do {
      backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: url)
    } catch let error1 as NSError {
      error = error1
      backgroundMusicPlayer = nil
    }

    if let player = backgroundMusicPlayer {
      player.numberOfLoops = -1
      player.volume = volume
      player.prepareToPlay()
      player.play()
    } else {
      print("Could not create audio player: \(error!)")
    }
  }
  
  func playSoundEffect(filename: String, volume: Float) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)

    if (url == nil) {
      print("Could not find file: \(filename)")
      return
    }
    
    var error: NSError? = nil

    do {
      soundEffectPlayer = try AVAudioPlayer(contentsOfURL: url)
    } catch let error1 as NSError {
      error = error1
      soundEffectPlayer = nil
    }

    if let player = soundEffectPlayer {
      player.numberOfLoops = 0
      player.volume = volume
      player.prepareToPlay()
      player.play()
    } else {
      print("Could not create audio player: \(error!)")
    }
  }
}