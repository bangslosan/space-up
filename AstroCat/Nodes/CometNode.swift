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
  let type: CometType

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

    default:
      texture = SKTextureAtlas(named: "CometMedium").textureNamed("CometMedium0")
      size = CGSize(width: 200 * ratio, height: 200 * ratio)
    }

    super.init(texture: texture, color: nil, size: size)
    
    // Physics
    physicsBody = SKPhysicsBody(rectangleOfSize: size)
    physicsBody!.categoryBitMask = PhysicsCategory.Comet
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
      SKAction.moveTo(toPosition, duration:duration, timingMode: .EaseIn),
      SKAction.runBlock { completion?() }
    ])
    
    runAction(action, withKey: KeyForAction.moveFromPositionAction)
  }
}
