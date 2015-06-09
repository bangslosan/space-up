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
}

class ShieldNode: SKSpriteNode {
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
    let rotationAction = SKAction.rotateByAngle(CGFloat(M_PI) * 2, duration: 1)

    runAction(SKAction.repeatActionForever(rotationAction), withKey: KeyForAction.rotationAction)
  }
  
  func stopAnimate() {
    removeActionForKey(KeyForAction.rotationAction)
  }
}
