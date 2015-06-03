//
//  GroundNode.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class GroundNode: SKSpriteNode {
  init(size: CGSize) {
    let color = UIColor(hexString: "#cccccc")

    super.init(texture: nil, color: color, size: size)
    
    // Anchor
    anchorPoint = CGPoint(x: 0, y: 0)

    // Physics
    physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin: CGPointZero, size: size))
    physicsBody!.categoryBitMask = PhysicsCategory.Ground
    physicsBody!.contactTestBitMask = PhysicsCategory.Player
    physicsBody!.restitution = 0
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
