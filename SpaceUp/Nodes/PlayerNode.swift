//
//  PlayerNode.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let movementSoundAction = "movementSoundAction"
  static let killSoundAction = "killSoundAction"
}

class PlayerNode: SKSpriteNode {
  // MAKR: - Immutable vars
  let textureAtlas = SKTextureAtlas(named: TextureAtlasFileName.Character)
  let energyBar = EnergyBarNode(size: CGSize(width: 140, height: 16))

  // MARK: - Vars
  private(set) var isAlive: Bool = true
  var shouldMove: Bool = false
  var distanceTravelled: CGFloat = 0
  var initialPosition: CGPoint?
  var shieldNode: ShieldNode?

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
  
  lazy var movementSoundAction: SKAction = {
    let action = SKAction.playSoundFileNamed(SoundFileName.Flying, waitForCompletion: true)
    
    return SKAction.repeatActionForever(action)
  }()
  
  lazy var killSoundAction: SKAction = SKAction.playSoundFileNamed(SoundFileName.Explosion, waitForCompletion: false)
  
  lazy var moveUpAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      self.textureAtlas.textureNamed(TextureFileName.MuffyFlying)
    ], timePerFrame: 1/60)
  }()
  
  lazy var stopMoveUpAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      self.textureAtlas.textureNamed(TextureFileName.MuffyStopFlying)
    ], timePerFrame: 1/60)
    }()
  
  lazy var killAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      self.textureAtlas.textureNamed(TextureFileName.MuffyDead)
    ], timePerFrame: 1/60)
  }()
  
  lazy var standAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      self.textureAtlas.textureNamed(TextureFileName.MuffyStanding)
    ], timePerFrame: 1/60)
  }()

  // MARK: - Init
  init() {
    let texture = textureAtlas.textureNamed(TextureFileName.MuffyStanding)
    let ratio: CGFloat = 1/3
    let size = CGSize(width: 520 * ratio, height: 680 * ratio)
    
    super.init(texture: texture, color: UIColor.clearColor(), size: size)
    
    // Anchor
    anchorPoint = CGPoint(x: 0.5, y: 0)
    
    // Physics
    physicsBody = physicsBodyOfSize(size)
    
    // Energy
    energyBar.position = CGPoint(x: -energyBar.frame.width / 2, y: size.height + 20)
    addChild(energyBar)
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
      runAction(killSoundAction, when: isSoundEnabled())
      
    case .Flying:
      removeActionForKey(KeyForAction.movementSoundAction)
      runAction(movementSoundAction, withKey: KeyForAction.movementSoundAction, when: isSoundEnabled())
      runAction(moveUpAnimateAction)
      
    case .Dropping:
      removeActionForKey(KeyForAction.movementSoundAction)
      runAction(stopMoveUpAnimateAction)
      
    case .Standing:
      runAction(standAnimateAction)
      
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
    physicsBody.contactTestBitMask = PhysicsCategory.Comet | PhysicsCategory.Fuel | PhysicsCategory.Ground
    physicsBody.restitution = 0
    physicsBody.friction = 0.5
    physicsBody.allowsRotation = false
    physicsBody.usesPreciseCollisionDetection = true
    physicsBody.velocity = velocity ?? CGVector(dx: 0, dy: 0)
    
    return physicsBody
  }
}
