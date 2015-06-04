//
//  CometNode.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let moveFromPositionAction = "moveFromPositionAction"
}

class CometNode: SKSpriteNode {
  // MARK: - Immutable vars
  let type: CometType
  
  // MARK: - Vars
  weak var emitter: CometEmitter?
  var enabled: Bool = true

  init(type: CometType) {
    self.type = type

    let ratio: CGFloat = 1/3
    let texture: SKTexture
    let size: CGSize

    switch type {
    case .Slow:
      texture = SKTextureAtlas(named: "CometLarge").textureNamed("CometLarge0")
      size = CGSize(width: 450 * ratio, height: 450 * ratio)

    case .Fast:
      texture = SKTextureAtlas(named: "CometSmall").textureNamed("CometSmall0")
      size = CGSize(width: 60 * ratio, height: 60 * ratio)
      
    case .Award:
      texture = SKTextureAtlas(named: "CometStar").textureNamed("CometStar0")
      size = CGSize(width: 100 * ratio, height: 100 * ratio)

    default:
      texture = SKTextureAtlas(named: "CometMedium").textureNamed("CometMedium0")
      size = CGSize(width: 200 * ratio, height: 200 * ratio)
    }

    super.init(texture: texture, color: nil, size: size)
    
    // Physics
    physicsBody = SKPhysicsBody(rectangleOfSize: size)
    physicsBody!.categoryBitMask = type == .Award ? PhysicsCategory.Award : PhysicsCategory.Comet
    physicsBody!.collisionBitMask = 0
    physicsBody!.contactTestBitMask = PhysicsCategory.Player
    physicsBody!.affectedByGravity = false
    physicsBody!.usesPreciseCollisionDetection = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Movement
  func moveFromPosition(position: CGPoint, toPosition: CGPoint, duration: NSTimeInterval, completion: (() -> Void)?) {
    self.position = position
    
    let action = SKAction.sequence([
      SKAction.moveTo(toPosition, duration: duration, timingMode: .Linear),
      SKAction.runBlock { completion?() }
    ])
    
    runAction(action, withKey: KeyForAction.moveFromPositionAction)
  }
  
  func cancelMovement() {
    removeActionForKey(KeyForAction.moveFromPositionAction)
  }
}
