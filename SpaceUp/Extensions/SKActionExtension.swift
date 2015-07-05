//
//  SKActionExtension.swift
//  SpaceUp
//
//  Created by David Chin on 23/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit
import AVFoundation

extension SKAction {
  class func moveTo(location: CGPoint, duration sec: NSTimeInterval, timingMode: SKActionTimingMode) -> SKAction {
    let action = moveTo(location, duration: sec)

    action.timingMode = timingMode
  
    return action
  }
  
  class func playSoundFileNamed(soundFile: String, volume: Float, waitForCompletion wait: Bool) -> SKAction {
    let url = NSBundle.mainBundle().URLForResource(soundFile, withExtension: nil)
    let audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)

    audioPlayer.volume = volume
    audioPlayer.prepareToPlay()
    
    return SKAction.sequence([
      SKAction.runBlock {
        audioPlayer.play()
      },
      SKAction.waitForDuration(audioPlayer.duration)
    ])
  }
}
