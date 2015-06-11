//
//  CometEmitter.swift
//  SpaceUp
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let emitCometAction = "emitCometAction"
}

class CometEmitter {
  // MARK: - Vars
  weak var populator: CometPopulator?
  weak var cometPath: CometPathNode?
  var shouldAward: Bool = false

  // MARK: - Immutable vars
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
      duration *= 0.6
      
    default:
      break
    }
    
    self.duration = duration
  }
  
  deinit {
    endEmit()
  }
  
  // MARK: - Populate
  func startEmit(#speedFactor: CGFloat, initialPercentage: CGFloat) {
    if let world = populator?.world {
      // Only the add the same action once
      if world.hasActionForKey(KeyForAction.emitCometAction) {
        return
      }

      let initialPercentage = initialPercentage.clamped(0, 1)
      let delayDuration = duration - (duration * 0.1 + duration * 0.5 * Double(speedFactor))
      
      var actions = [SKAction]()
      var startPosition = CGPoint(x: fromPosition.x + (toPosition.x - fromPosition.x) * initialPercentage,
                                  y: fromPosition.y + (toPosition.y - fromPosition.y) * initialPercentage)
      
      // Comet
      let cometAction = SKAction.sequence([
        SKAction.runBlock { [weak self] in
          if let emitter = self {
            let comet = emitter.addComet()
            
            emitter.revealComet(comet, fromPosition: startPosition, toPosition: emitter.toPosition)

            startPosition = emitter.fromPosition
          }
        },
        SKAction.waitForDuration(delayDuration)
      ])
      
      actions << SKAction.repeatActionForever(cometAction)
      
      // Award
      if shouldAward {
        let awardAction = SKAction.sequence([
          SKAction.waitForDuration(delayDuration * 0.5),
          SKAction.runBlock { [weak self] in
            if let emitter = self {
              let comet = emitter.addCometOfType(.Award)
              
              emitter.revealComet(comet, fromPosition: emitter.fromPosition, toPosition: emitter.toPosition)
            }
          },
          SKAction.waitForDuration(delayDuration * 0.5)
        ])
        
        actions << SKAction.repeatActionForever(awardAction)
      }
      
      world.runAction(SKAction.group(actions), withKey: "\(KeyForAction.emitCometAction)-\(uid)")
    }
  }
  
  func endEmit() {
    populator?.world?.removeActionForKey("\(KeyForAction.emitCometAction)-\(uid)")
  }

  // MARK: - Add / Remove
  func addComet() -> CometNode {
    return addCometOfType(type)
  }

  func addCometOfType(type: CometType) -> CometNode {
    let comet = CometNode(type: type)
    
    comet.emitter = self
    populator?.world?.addChild(comet)
    comets.addObject(comet)
    
    return comet
  }
  
  func removeComet(comet: CometNode) {
    comet.cancelMovement()
    comet.removeFromParent()
    comets.removeObject(comet)
  }
  
  func removeAllComets() {
    if let comets = comets.allObjects as? [CometNode] {
      for comet in comets {
        removeComet(comet)
      }
    }
  }
  
  func revealComet(comet: CometNode, fromPosition: CGPoint, toPosition: CGPoint, completion: (() -> Void)? = nil) {
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
