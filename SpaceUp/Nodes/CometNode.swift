//
//  CometNode.swift
//  SpaceUp
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
  let textureAtlas = SKTextureAtlas(named: TextureAtlasFileName.Environment)
  let type: CometType
  
  // MARK: - Vars
  weak var emitter: CometEmitter?
  var enabled: Bool = true

  // MARK: - Init
  init(type: CometType) {
    self.type = type

    let ratio: CGFloat = 1/3
    let texture: SKTexture
    let size: CGSize

    switch type {
    case .Slow:
      texture = textureAtlas.textureNamed(TextureFileName.CometLarge)
      size = CGSize(width: 400 * ratio, height: 400 * ratio)

    case .Fast:
      texture = textureAtlas.textureNamed(TextureFileName.CometSmall)
      size = CGSize(width: 60 * ratio, height: 60 * ratio)
      
    case .Award:
      texture = textureAtlas.textureNamed(TextureFileName.CometStar)
      size = CGSize(width: 100 * ratio, height: 100 * ratio)

    default:
      texture = textureAtlas.textureNamed(TextureFileName.CometMedium)
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
  
  // MARK: Removal
  func removeFromEmitter() {
    enabled = false
    emitter?.removeComet(self)
  }

  func explodeAndRemove() {
    if let parent = parent {
      // Add explosion effect
      let explosionEmitter = SKEmitterNode(fileNamed: "Explosion.sks")

      explosionEmitter.position = position
      parent.addChild(explosionEmitter)
      
      afterDelay(2) {
        explosionEmitter.removeFromParent()
      }
    }
    
    // Remove itself
    removeFromEmitter()
  }
}
