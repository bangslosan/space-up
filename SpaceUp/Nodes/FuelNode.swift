//
//  FuelNode.swift
//  SpaceUp
//
//  Created by David Chin on 10/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class FuelNode: SKSpriteNode {
  init() {
    let size = CGSize(width: 10, height: 10)
    let color = UIColor.redColor()

    super.init(texture: nil, color: color, size: size)
    
    // Physics
    physicsBody = SKPhysicsBody(rectangleOfSize: size)
    physicsBody!.categoryBitMask = PhysicsCategory.Fuel
    physicsBody!.collisionBitMask = 0
    physicsBody!.contactTestBitMask = PhysicsCategory.Player
    physicsBody!.affectedByGravity = false
    physicsBody!.usesPreciseCollisionDetection = true
    
    // Animate
    let rotationAction = SKAction.rotateByAngle(CGFloat(M_PI) * 2, duration: 2)
    runAction(SKAction.repeatActionForever(rotationAction))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
