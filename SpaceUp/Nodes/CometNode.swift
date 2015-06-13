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
  let physicsFrame: CGRect
  
  // MARK: - Vars
  weak var emitter: CometEmitter?
  var enabled: Bool = true

  // MARK: - Init
  init(type: CometType) {
    self.type = type

    let texture: SKTexture
    let textureSize: CGSize
    let radius: CGFloat
    let center: CGPoint

    switch type {
    case .Slow:
      texture = textureAtlas.textureNamed(TextureFileName.CometLarge)
      center = CGPoint(x: 284, y: 150)
      radius = 99

    case .Fast:
      texture = textureAtlas.textureNamed(TextureFileName.CometSmall)
      center = CGPoint(x: 134, y: 59)
      radius = 36
      
    case .Award:
      texture = textureAtlas.textureNamed(TextureFileName.CometStar)
      center = CGPoint(x: 117, y: 44)
      radius = 25

    default:
      texture = textureAtlas.textureNamed(TextureFileName.CometMedium)
      center = CGPoint(x: 240, y: 115)
      radius = 63
    }
    
    textureSize = texture.size()
    physicsFrame = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)

    super.init(texture: texture, color: nil, size: textureSize)
    
    // Anchor
    anchorPoint = CGPoint(x: center.x / textureSize.width, y: center.y / textureSize.height)
    
    // Physics
    physicsBody = SKPhysicsBody(circleOfRadius: radius)
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
      let explosionEmitter = SKEmitterNode(fileNamed: EffectFileName.Explosion)

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
