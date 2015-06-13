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
  var physicsFrame = CGRectZero

  // MARK: - Init
  init(type: CometType, isReversed: Bool = false) {
    self.type = type

    super.init(texture: nil, color: nil, size: CGSizeZero)
    
    // Configuration
    let (texture, anchorPoint, physicsFrame) = configurationOfType(type, isReversed: isReversed)
    
    self.texture = texture
    self.size = texture.size()
    self.physicsFrame = physicsFrame
    self.anchorPoint = anchorPoint
    
    // Physics
    physicsBody = SKPhysicsBody(circleOfRadius: physicsFrame.width / 2)
    physicsBody!.categoryBitMask = type == .Award ? PhysicsCategory.Award : PhysicsCategory.Comet
    physicsBody!.collisionBitMask = 0
    physicsBody!.contactTestBitMask = PhysicsCategory.Player
    physicsBody!.affectedByGravity = false
    physicsBody!.usesPreciseCollisionDetection = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configurationOfType(type: CometType, isReversed: Bool) -> (texture: SKTexture, anchorPoint: CGPoint, physicsFrame: CGRect) {
    let texture: SKTexture
    let center: CGPoint
    let anchorPoint: CGPoint
    let radius: CGFloat
    let physicsFrame: CGRect
    
    switch type {
    case .Slow:
      texture = textureAtlas.textureNamed(isReversed ? TextureFileName.CometLargeUp : TextureFileName.CometLarge)
      center = isReversed ? CGPoint(x: 167, y: 276) : CGPoint(x: 284, y: 150)
      radius = 99
      
    case .Fast:
      texture = textureAtlas.textureNamed(isReversed ? TextureFileName.CometSmallUp : TextureFileName.CometSmall)
      center = isReversed ? CGPoint(x: 81, y: 105) : CGPoint(x: 134, y: 59)
      radius = 36
      
    case .Award:
      texture = textureAtlas.textureNamed(isReversed ? TextureFileName.CometStarUp : TextureFileName.CometStar)
      center = isReversed ? CGPoint(x: 55, y: 99) : CGPoint(x: 117, y: 44)
      radius = 25
      
    default:
      texture = textureAtlas.textureNamed(isReversed ? TextureFileName.CometMediumUp : TextureFileName.CometMedium)
      center = isReversed ? CGPoint(x: 143, y: 218) : CGPoint(x: 240, y: 115)
      radius = 63
    }
    
    let textureSize = texture.size()
    anchorPoint = CGPoint(x: center.x / textureSize.width, y: center.y / textureSize.height)
    physicsFrame = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
    
    return (texture, anchorPoint, physicsFrame)
  }
  
  // MARK: - Movement
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
  
  // MARK: - Removal
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
