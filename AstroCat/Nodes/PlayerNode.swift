//
//  PlayerNode.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let movementSoundAction = "movementSoundAction"
}

class PlayerNode: SKSpriteNode {
  // MARK: - Vars
  private(set) var isAlive: Bool = true
  var shouldMove: Bool = false
  var distanceTravelled: CGFloat = 0
  var initialPosition: CGPoint?
  var shieldNode: ShieldNode?
  
  var isProtected: Bool = false {
    didSet {
      isProtected ? addShield() : removeShield()
    }
  }
  
  lazy var movementSoundAction: SKAction = { () -> SKAction in
    let action = SKAction.playSoundFileNamed("Meow.wav", waitForCompletion: true)
    
    return SKAction.repeatActionForever(action)
  }()
  
  lazy var killSoundAction: SKAction = SKAction.playSoundFileNamed("Explode.wav", waitForCompletion: false)

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
  
  // MARK: - Life
  func kill() {
    runAction(killSoundAction)
    
    reset()
    isAlive = false
  }
  
  func respawn() {
    reset()
  }
  
  private func reset() {
    physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    isAlive = true
    isProtected = false
    shouldMove = false
    distanceTravelled = 0
    
    // Stop sound loop
    removeActionForKey(KeyForAction.movementSoundAction)
  }
  
  // MARK: - Movement
  func jump() {
    if let physicsBody = physicsBody {
      let magnitude: CGFloat = physicsBody.mass * 1000
      let angle = CGFloat(M_PI_2) - abs(zRotation % CGFloat(M_PI_2))
      let dx = -zRotation.sign() * cos(angle) * magnitude
      let dy = sin(angle) * magnitude
      let vector = CGVector(dx: dx, dy: dy)
      
      // Apply force
      physicsBody.applyImpulse(vector)
    }
  }
  
  func moveUpward() {
    if let physicsBody = physicsBody where physicsBody.velocity.length() < 1500 {
      let magnitude: CGFloat = physicsBody.mass * 5000
      let angle = CGFloat(M_PI_2) - abs(zRotation % CGFloat(M_PI_2))
      let dx = -zRotation.sign() * cos(angle) * magnitude
      let dy = sin(angle) * magnitude
      let vector = CGVector(dx: dx, dy: dy)
      
      // Apply force
      physicsBody.applyForce(vector)
    }
  }
  
  func startMoveUpward() {
    shouldMove = true
    
    removeActionForKey(KeyForAction.movementSoundAction)
    runAction(movementSoundAction, withKey: KeyForAction.movementSoundAction)
  }
  
  func endMoveUpward() {
    shouldMove = false

    removeActionForKey(KeyForAction.movementSoundAction)
  }
  
  func brake() {
    if let physicsBody = physicsBody where physicsBody.velocity.dy > 0 {
      let finalVelocity = CGVector(dx: physicsBody.velocity.dy, dy: 0)
      let easing: CGFloat = 0.05
      
      physicsBody.velocity += CGVector(dx: 0, dy: (finalVelocity.dy - physicsBody.velocity.dy) * easing)
    }
  }
  
  func updateDistanceTravelled() {
    if let initialPosition = initialPosition {
      distanceTravelled = position.y - initialPosition.y
    }
  }
  
  // MARK: - Comet
  func isAboveCometPath(emitter: CometEmitter) -> Bool {
    let pointOnPath = lineFromPoint(emitter.fromPosition, toPoint: emitter.toPosition)(pointAtX: position.x)
    
    return position.y > pointOnPath.y
  }
  
  // MARK: - Protection
  private func addShield() {
    if shieldNode == nil {
      let diameter = max(frame.width, frame.height) + 20

      shieldNode = ShieldNode(size: CGSize(width: diameter, height: diameter))
      shieldNode!.position = CGPoint(x: 0, y: frame.height * 0.5)
      shieldNode!.zPosition = 20
      addChild(shieldNode!)
    }
  }
  
  private func removeShield() {
    if shieldNode != nil {
      shieldNode!.removeFromParent()
      shieldNode = nil
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
    physicsBody.contactTestBitMask = PhysicsCategory.Comet | PhysicsCategory.Food | PhysicsCategory.Player
    physicsBody.restitution = 0
    physicsBody.friction = 0.5
    physicsBody.allowsRotation = false
    physicsBody.usesPreciseCollisionDetection = true
    physicsBody.velocity = velocity ?? CGVector(dx: 0, dy: 0)
    
    return physicsBody
  }
}
