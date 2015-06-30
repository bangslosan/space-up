//
//  PlayerNode.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let moveToSideAction = "moveToSideAction"
  static let movementSoundAction = "movementSoundAction"
  static let killSoundAction = "killSoundAction"
}

class PlayerNode: SKSpriteNode {
  // MARK: - Vars
  private lazy var engineFlame = EngineFlameNode()
  private(set) var shieldNode: ShieldNode?
  private(set) var isAlive: Bool = true
  var shouldMove: Bool = false
  var initialPosition: CGPoint?
  var distanceTravelled: CGFloat = 0

  var state: PlayerState = .Standing {
    didSet {
      runAnimationForState(state)
    }
  }
  
  var isProtected: Bool = false {
    didSet {
      isProtected ? addShield() : removeShield()
    }
  }
  
  private lazy var movementSoundAction: SKAction = {
    let action = SKAction.playSoundFileNamed(SoundFileName.Flying, waitForCompletion: true)
    
    return SKAction.repeatActionForever(action)
  }()
  
  private lazy var killSoundAction: SKAction = SKAction.playSoundFileNamed(SoundFileName.Explosion, waitForCompletion: false)
  
  private lazy var moveUpAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      SKTexture(imageNamed: TextureFileName.MuffyFlying + "1"),
      SKTexture(imageNamed: TextureFileName.MuffyFlying + "2")
    ], timePerFrame: 1/30)
  }()
  
  private lazy var stopMoveUpAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      SKTexture(imageNamed: TextureFileName.MuffyStopFlying + "1"),
      SKTexture(imageNamed: TextureFileName.MuffyStopFlying + "2")
    ], timePerFrame: 1/30)
  }()
  
  private lazy var killAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      SKTexture(imageNamed: TextureFileName.MuffyDead + "1"),
      SKTexture(imageNamed: TextureFileName.MuffyDead + "2"),
      SKTexture(imageNamed: TextureFileName.MuffyDead + "3"),
      SKTexture(imageNamed: TextureFileName.MuffyDead + "4"),
      SKTexture(imageNamed: TextureFileName.MuffyDead + "5")
    ], timePerFrame: 1/30)
  }()
  
  private lazy var killRotationAction: SKAction = {
    let action = SKAction.rotateByAngle(CGFloat(-90).degreesToRadians(), duration: 1)
    
    action.timingMode = SKActionTimingMode.EaseOut
    
    return action
  }()
  
  private lazy var standAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      SKTexture(imageNamed: TextureFileName.MuffyStanding)
    ], timePerFrame: 1/60)
  }()

  // MARK: - Init
  init() {
    let texture = SKTexture(imageNamed: TextureFileName.MuffyStanding)
    let ratio: CGFloat = 1/3
    let size = CGSize(width: 520 * ratio, height: 680 * ratio)
    
    super.init(texture: texture, color: UIColor.clearColor(), size: size)
    
    // Anchor
    anchorPoint = CGPoint(x: 0.5, y: 0.18)
    
    // Physics
    physicsBody = physicsBodyOfSize(size)
    
    // Flame
    engineFlame.position = CGPoint(x: 30, y: -20)
    engineFlame.stopAnimate()
    addChild(engineFlame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life
  func kill() {
    reset()
    isAlive = false
    
    // Movement
    endMoveUpward()
    
    // Animate
    state = .Dying
  }
  
  func respawn() {
    reset()
    stand()
  }
  
  func stand() {
    state = .Standing
    zRotation = 0
  }
  
  func reset() {
    physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    isAlive = true
    isProtected = false
    shouldMove = false
    distanceTravelled = 0
    
    // Stop sound loop
    removeActionForKey(KeyForAction.movementSoundAction)
  }
  
  // MARK: - Movement
  func jump(magnitude: CGFloat = 1000) {
    if let physicsBody = physicsBody where physicsBody.velocity.length() < MaximumPlayerResultantVelocity {
      let magnitude: CGFloat = physicsBody.mass * magnitude
      let angle = CGFloat(M_PI_2) - abs(zRotation % CGFloat(M_PI_2))
      let dx = -zRotation.sign() * cos(angle) * magnitude
      let dy = sin(angle) * magnitude
      let vector = CGVector(dx: dx, dy: dy)
      
      // Apply force
      physicsBody.applyImpulse(vector)
    }
  }
  
  func moveUpward(magnitude: CGFloat = 5000) {
    if let physicsBody = physicsBody where physicsBody.velocity.length() < MaximumPlayerResultantVelocity {
      let magnitude: CGFloat = physicsBody.mass * magnitude
      let angle = CGFloat(M_PI_2) - abs(zRotation % CGFloat(M_PI_2))
      let dx = -zRotation.sign() * cos(angle) * magnitude
      let dy = sin(angle) * magnitude
      let vector = CGVector(dx: dx, dy: dy)
      
      // Apply force
      physicsBody.applyForce(vector)
    }
  }
  
  func moveByMotion(motion: FilteredMotion) {
    if let scene = scene where abs(motion.acceleration.x) > 0.08 {
      let x = position.x + CGFloat(motion.acceleration.x) * 20
      
      position.x = x.clamped(scene.screenFrame.midX - 150, scene.screenFrame.midX + 150)
    }
  }
  
  func startMoveUpward() {
    shouldMove = true
    
    // Animate
    state = .Flying
  }

  func endMoveUpward() {
    shouldMove = false
    
    // Animate
    state = .Dropping
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
  
  // MARK: - Animation
  func runAnimationForState(state: PlayerState) {
    switch state {
    case .Dying:
      runAction(killAnimateAction)
      runAction(killRotationAction)
      runAction(killSoundAction, when: isSoundEnabled())
      
    case .Flying:
      removeActionForKey(KeyForAction.movementSoundAction)
      runAction(movementSoundAction, withKey: KeyForAction.movementSoundAction, when: isSoundEnabled())
      runAction(moveUpAnimateAction)
      
      engineFlame.animate()
      
    case .Dropping:
      removeActionForKey(KeyForAction.movementSoundAction)
      runAction(stopMoveUpAnimateAction)
      
      engineFlame.stopAnimate()
      
    case .Standing:
      if isAlive {
        runAction(standAnimateAction)
      }
      
    default:
      break
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
      let diameter: CGFloat = 230

      shieldNode = ShieldNode(size: CGSize(width: diameter, height: diameter))
      shieldNode!.position = CGPoint(x: 0, y: diameter * 0.5 - 30)
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
    var ratio: CGFloat = 1/3

    CGPathMoveToPoint(path, nil, 250 * ratio - offsetX, size.height - 560 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 155 * ratio - offsetX, size.height - 470 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 195 * ratio - offsetX, size.height - 400 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 75 * ratio - offsetX, size.height - 295 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 110 * ratio - offsetX, size.height - 205 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 260 * ratio - offsetX, size.height - 150 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 390 * ratio - offsetX, size.height - 280 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 330 * ratio - offsetX, size.height - 390 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 340 * ratio - offsetX, size.height - 515 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 285 * ratio - offsetX, size.height - 525 * ratio - offsetY)
    CGPathAddLineToPoint(path, nil, 285 * ratio - offsetX, size.height - 560 * ratio - offsetY)
    
    CGPathCloseSubpath(path)
    
    return path
  }
  
  private func physicsBodyOfSize(size: CGSize) -> SKPhysicsBody {
    let velocity = self.physicsBody?.velocity
    let path = physicsBodyPathOfSize(size)
    let physicsBody = SKPhysicsBody(polygonFromPath: path)
    
    physicsBody.categoryBitMask = PhysicsCategory.Player
    physicsBody.collisionBitMask = PhysicsCategory.Ground
    physicsBody.contactTestBitMask = PhysicsCategory.Comet | PhysicsCategory.Food | PhysicsCategory.Ground
    physicsBody.restitution = 0
    physicsBody.friction = 0.5
    physicsBody.allowsRotation = false
    physicsBody.usesPreciseCollisionDetection = true
    physicsBody.velocity = velocity ?? CGVector(dx: 0, dy: 0)
    
    return physicsBody
  }
}
