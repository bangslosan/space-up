//
//  CometPopulator.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let addCometAction = "addCometAction"
}

class CometPopulator {
  weak var world: WorldNode?

  init() {
  }
  
  // MARK: - Populate
  func startPopulate() {
    if let world = world {
      // Only the add the same action once
      if world.hasActionForKey(KeyForAction.addCometAction) {
        return
      }

      let sequenceAction = SKAction.sequence([
        SKAction.runBlock {
          self.addComet()
        },
        SKAction.waitForDuration(1)
      ])

      let repeatAction = SKAction.repeatActionForever(sequenceAction)
      
      world.runAction(repeatAction, withKey: KeyForAction.addCometAction)
    }
  }
  
  func endPopulate() {
    world?.removeActionForKey(KeyForAction.addCometAction)
  }
  
  // MARK: - Add / Remove
  func addComet() -> CometNode {
    let comet = CometNode()
    
    if let world = world, scene = world.scene {
      let sceneFrame = world.convertFrame(scene.frame, fromNode: scene)
      
      let fromPosition = CGPoint(x: sceneFrame.maxX, y: sceneFrame.maxY)
      let toPosition = CGPoint(x: sceneFrame.minX, y: sceneFrame.midY)
      
      comet.moveFromPosition(fromPosition, toPosition: toPosition) {
        self.removeComet(comet)
      }

      world.addChild(comet)
    }
    
    return comet
  }
  
  func removeComet(comet: CometNode) {
    comet.removeFromParent()
  }
}
