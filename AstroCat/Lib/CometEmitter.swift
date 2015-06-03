//
//  CometEmitter.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let emitCometAction = "emitCometAction"
}

class CometEmitter {
  weak var populator: CometPopulator?

  let comets = NSHashTable.weakObjectsHashTable()
  let speed: CGFloat
  let fromPosition: CGPoint
  let toPosition: CGPoint
  let duration: NSTimeInterval
  
  // MARK: - Init
  init(speed: CGFloat, fromPosition: CGPoint, toPosition: CGPoint) {
    self.speed = speed
    self.fromPosition = fromPosition
    self.toPosition = toPosition
    self.duration = NSTimeInterval(toPosition.distanceTo(fromPosition) / speed)
  }
  
  // MARK: - Populate
  func startEmit() {
    if let world = populator?.world {
      // Only the add the same action once
      if world.hasActionForKey(KeyForAction.emitCometAction) {
        return
      }
      
      let sequenceAction = SKAction.sequence([
        SKAction.runBlock {
          self.addComet()
        },
        SKAction.waitForDuration(self.duration)
      ])
      
      let repeatAction = SKAction.repeatActionForever(sequenceAction)
      
      world.runAction(repeatAction, withKey: KeyForAction.emitCometAction)
    }
  }
  
  func endEmit() {
    populator?.world?.removeActionForKey(KeyForAction.emitCometAction)
  }

  // MARK: - Add / Remove
  func addComet() -> CometNode {
    let comet = CometNode()
    
    populator?.world?.addChild(comet)
    comets.addObject(comet)
    
    // Reveal
    revealComet(comet)
    
    return comet
  }
  
  func removeComet(comet: CometNode) {
    comet.removeFromParent()
    comets.removeObject(comet)
  }
  
  func revealComet(comet: CometNode) {
    if let world = populator?.world, scene = world.scene {
      comet.moveFromPosition(fromPosition, toPosition: toPosition, duration: duration) {
        self.removeComet(comet)
      }
    }
  }
}
