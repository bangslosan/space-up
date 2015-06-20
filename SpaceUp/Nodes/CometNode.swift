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
  static let rotationAction = "rotationAction"
  static let glowAction = "glowAction"
}

class CometNode: SKSpriteNode {
  // MARK: - Immutable vars
  let textureAtlas = SKTextureAtlas(named: TextureAtlasFileName.Environment)
  let type: CometType
  let sphere: SKSpriteNode
  let glow: SKSpriteNode
  
  // MARK: - Vars
  weak var emitter: CometEmitter?
  var sphereHighlight: SphereHighlightNode?
  var enabled: Bool = true
  var physicsFrame = CGRectZero

  // MARK: - Init
  init(type: CometType, isReversed: Bool = false) {
    self.type = type

    let radius: CGFloat
    
    switch type {
    case .Slow:
      sphere = SKSpriteNode(imageNamed: TextureFileName.CometLarge)
      glow = SKSpriteNode(imageNamed: TextureFileName.CometLargeGlow)
      glow.anchorPoint = CGPoint(x: 0.68, y: 0.38)
      radius = 99
      
    case .Fast:
      sphere = SKSpriteNode(imageNamed: TextureFileName.CometSmall)
      glow = SKSpriteNode(imageNamed: TextureFileName.CometSmallGlow)
      glow.anchorPoint = CGPoint(x: 0.68, y: 0.38)
      radius = 36
      
    case .Award:
      sphere = SKSpriteNode(imageNamed: TextureFileName.CometStar)
      glow = SKSpriteNode(imageNamed: TextureFileName.CometStarGlow)
      radius = 25
      
    default:
      sphere = SKSpriteNode(imageNamed: TextureFileName.CometMedium)
      glow = SKSpriteNode(imageNamed: TextureFileName.CometMediumGlow)
      glow.anchorPoint = CGPoint(x: 0.68, y: 0.38)
      radius = 63
    }

    physicsFrame = CGRect(x: radius, y: radius, width: radius * 2, height: radius * 2)

    super.init(texture: nil, color: nil, size: sphere.texture!.size())
    
    // Sphere
    addChild(sphere)

    // Glow
    glow.zPosition = 1
    glow.blendMode = SKBlendMode.Screen
    
    if isReversed {
      glow.xScale = -1
      glow.yScale = -1
    }
    
    addChild(glow)
    
    // Highlight
    if type != .Award {
      sphereHighlight = SphereHighlightNode(radius: radius)
      addChild(sphereHighlight!)
    }

    // Physics
    physicsBody = SKPhysicsBody(circleOfRadius: physicsFrame.width / 2)
    physicsBody!.categoryBitMask = type == .Award ? PhysicsCategory.Award : PhysicsCategory.Comet
    physicsBody!.collisionBitMask = 0
    physicsBody!.contactTestBitMask = PhysicsCategory.Player
    physicsBody!.affectedByGravity = false
    physicsBody!.usesPreciseCollisionDetection = true
    
    // Animate
    animate()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
  
  // MARK: - Animate
  func animate() {
    let rotationAction = SKAction.rotateByAngle(CGFloat(M_PI) * 2, duration: 6)
    let glowAction = SKAction.sequence([
      SKAction.fadeAlphaTo(1, duration: 0.6),
      SKAction.fadeAlphaTo(0.5, duration: 0.6)
    ])
    
    glowAction.timingMode = SKActionTimingMode.EaseInEaseOut
    
    sphere.runAction(SKAction.repeatActionForever(rotationAction), withKey: KeyForAction.rotationAction)
    glow.runAction(SKAction.repeatActionForever(glowAction), withKey: KeyForAction.glowAction)
  }
  
  func stopAnimate() {
    sphere.removeActionForKey(KeyForAction.rotationAction)
    glow.removeActionForKey(KeyForAction.glowAction)
  }
}
