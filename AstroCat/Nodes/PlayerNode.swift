//
//  PlayerNode.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
  // MARK: - Vars
  var isAlive: Bool = true

  // MARK: - Init
  init() {
    let texture = SKTextureAtlas(named: "Cat").textureNamed("Cat0")
    let ratio: CGFloat = 1/6
    let size = CGSize(width: 430 * ratio, height: 460 * ratio)
    
    super.init(texture: texture, color: UIColor.clearColor(), size: size)
    
    // Anchor
    anchorPoint = CGPoint(x: 0.5, y: 0)
    
    // Physics
    physicsBody = physicsBodyOfSize(size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Movement
  func jump() {
    if let physicsBody = physicsBody {
      let jumpMagnitude: CGFloat = physicsBody.mass * 1000
      let angle = CGFloat(M_PI_2) - abs(zRotation % CGFloat(M_PI_2))
      let dx = -zRotation.sign() * cos(angle) * jumpMagnitude
      let dy = sin(angle) * jumpMagnitude
      let vector = CGVector(dx: dx, dy: dy)
      
      // Apply force
      physicsBody.applyImpulse(vector)
    }
  }
  
  // MARK: - Physics
  private func physicsBodyPathOfSize(size: CGSize) -> CGPath {
    var offsetX = CGFloat(size.width * anchorPoint.x)
    var offsetY = CGFloat(size.height * anchorPoint.y)
    var path = CGPathCreateMutable()
    var ratio: CGFloat = 1/6

    CGPathMoveToPoint(path, nil, 190 * ratio - offsetX, size.height - 460 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 135 * ratio - offsetX, size.height - 395 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 0 * ratio - offsetX, size.height - 275 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 0 * ratio - offsetX, size.height - 180 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 120 * ratio - offsetX, size.height - 0 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 190 * ratio - offsetX, size.height - 55 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 400 * ratio - offsetX, size.height - 70 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 310 * ratio - offsetX, size.height - 290 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 230 * ratio - offsetX, size.height - 460 * ratio - offsetY)
    
    CGPathCloseSubpath(path)
    
    return path
  }
  
  private func physicsBodyOfSize(size: CGSize) -> SKPhysicsBody {
    let velocity = self.physicsBody?.velocity
    let path = physicsBodyPathOfSize(size)
    let physicsBody = SKPhysicsBody(polygonFromPath: path)
    
    physicsBody.categoryBitMask = PhysicsCategory.Player
    physicsBody.collisionBitMask = PhysicsCategory.Ground
    physicsBody.contactTestBitMask = PhysicsCategory.Food
    physicsBody.restitution = 0
    physicsBody.friction = 0.5
    physicsBody.allowsRotation = false
    physicsBody.usesPreciseCollisionDetection = true
    physicsBody.velocity = velocity ?? CGVector(dx: 0, dy: 0)
    
    return physicsBody
  }
}
