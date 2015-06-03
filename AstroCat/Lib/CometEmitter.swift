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
  weak var cometPath: CometPathNode?

  let comets = NSHashTable.weakObjectsHashTable()
  let speed: CGFloat
  let fromPosition: CGPoint
  let toPosition: CGPoint
  let duration: NSTimeInterval
  let type: CometType
  
  private let uid = NSUUID().UUIDString
  
  // MARK: - Init
  init(type: CometType, speed: CGFloat, fromPosition: CGPoint, toPosition: CGPoint) {
    self.type = type
    self.speed = speed
    self.fromPosition = fromPosition
    self.toPosition = toPosition
    
    var duration = NSTimeInterval(toPosition.distanceTo(fromPosition) / speed)
    
    switch type {
    case .Slow:
      duration *= 2
    
    case .Fast:
      duration *= 0.5
      
    default:
      break
    }
    
    self.duration = duration
  }
  
  deinit {
    endEmit()
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
      
      world.runAction(repeatAction, withKey: "\(KeyForAction.emitCometAction)-\(uid)")
      
      // Path
      /*
      addCometPath()
      revealCometPath()
      */
    }
  }
  
  func endEmit() {
    // removeCometPath()
    populator?.world?.removeActionForKey("\(KeyForAction.emitCometAction)-\(uid)")
  }

  // MARK: - Add / Remove
  func addComet() -> CometNode {
    let comet = CometNode(type: type)
    
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
  
  func revealComet(comet: CometNode, completion: (() -> Void)? = nil) {
    if let world = populator?.world, scene = world.scene {
      comet.moveFromPosition(fromPosition, toPosition: toPosition, duration: duration) {
        self.removeComet(comet)
        
        completion?()
      }
    }
  }
  
  // MARK: - Path
  func addCometPath() -> CometPathNode {
    if self.cometPath != nil {
      return self.cometPath!
    }
    
    let cometPath = CometPathNode(fromPosition: fromPosition, toPosition: toPosition)
    
    populator?.world?.addChild(cometPath)
    self.cometPath = cometPath
    
    return cometPath
  }
  
  func removeCometPath() {
    cometPath?.removeFromParent()
  }
  
  func revealCometPath() {
    let action = SKAction.fadeInWithDuration(1)

    cometPath?.alpha = 0
    cometPath?.runAction(action)
  }
}
