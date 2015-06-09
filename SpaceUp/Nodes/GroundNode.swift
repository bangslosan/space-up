//
//  GroundNode.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class GroundNode: SKSpriteNode {
  init(size: CGSize) {
    let texture = SKTexture(imageNamed: TextureFileName.PlanetGround)

    super.init(texture: texture, color: nil, size: size)
    
    // Anchor
    anchorPoint = CGPoint(x: 0, y: 0)

    // Physics
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height - 60)
    physicsBody = SKPhysicsBody(edgeLoopFromRect: rect)
    physicsBody!.categoryBitMask = PhysicsCategory.Ground
    physicsBody!.contactTestBitMask = PhysicsCategory.Player
    physicsBody!.restitution = 0
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
