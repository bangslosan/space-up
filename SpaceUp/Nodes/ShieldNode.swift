//
//  ShieldNode.swift
//  SpaceUp
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let rotationAction = "rotationAction"
  static let glowAction = "glowAction"
}

class ShieldNode: SKSpriteNode {
  private lazy var glow: SKSpriteNode = {
    let glow = SKSpriteNode(imageNamed: TextureFileName.ShieldBlur)

    glow.alpha = 0.3
    glow.zPosition = 19
    glow.blendMode = SKBlendMode.Screen
    glow.color = UIColor(hexString: "#FBB300")
    glow.colorBlendFactor = 1

    return glow
  }()

  // MARK: - Init
  init(size: CGSize) {
    let texture = SKTexture(imageNamed: TextureFileName.Shield)

    super.init(texture: texture, color: nil, size: size)
    
    animate()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Animate
  func animate() {
    // Rotation
    let rotationAction = SKAction.rotateByAngle(CGFloat(M_PI) * 2, duration: 1)

    runAction(SKAction.repeatActionForever(rotationAction), withKey: KeyForAction.rotationAction)
    
    // Glow
    addChild(glow)
    
    let blurAction = SKAction.sequence([
      SKAction.fadeAlphaTo(0.1, duration: 0.6),
      SKAction.fadeAlphaTo(0.3, duration: 0.6)
    ])
    
    blurAction.timingMode = SKActionTimingMode.EaseInEaseOut
    
    glow.runAction(SKAction.repeatActionForever(blurAction))
  }
  
  func stopAnimate() {
    removeActionForKey(KeyForAction.rotationAction)
    glow.removeActionForKey(KeyForAction.rotationAction)
  }
}
