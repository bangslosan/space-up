//
//  EngineFlameNode.swift
//  SpaceUp
//
//  Created by David Chin on 21/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let engineAnimateAction = "engineAnimateAction"
}

class EngineFlameNode: SKSpriteNode {
  // MARK: - Vars
  private lazy var engineEmitterNode = SKEmitterNode(fileNamed: EffectFileName.EngineSpark)
  private lazy var flameStartAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      SKTexture(imageNamed: TextureFileName.EngineFlame + "1"),
      SKTexture(imageNamed: TextureFileName.EngineFlame + "2"),
      SKTexture(imageNamed: TextureFileName.EngineFlame + "3"),
      SKTexture(imageNamed: TextureFileName.EngineFlame + "4"),
      SKTexture(imageNamed: TextureFileName.EngineFlame + "5"),
      SKTexture(imageNamed: TextureFileName.EngineFlame + "6")
    ], timePerFrame: 1/30)
  }()
  
  private lazy var flamePersistAnimateAction: SKAction = {
    return SKAction.repeatActionForever(SKAction.animateWithTextures([
      SKTexture(imageNamed: TextureFileName.EngineFlame + "5"),
      SKTexture(imageNamed: TextureFileName.EngineFlame + "6")
    ], timePerFrame: 1/20))
  }()

  // MARK: - Init
  init() {
    let texture = SKTexture(imageNamed: TextureFileName.EngineFlame + "1")

    super.init(texture: texture, color: nil, size: texture.size())
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Animate
  func animate() {
    hidden = false

    // Action
    runAction(SKAction.sequence([
      flameStartAnimateAction,
      flamePersistAnimateAction
    ]), withKey: KeyForAction.engineAnimateAction)
    
    // Emitter
    /*
    engineEmitterNode.position = CGPoint(x: 0, y: 20)
    engineEmitterNode.resetSimulation()
    engineEmitterNode.addToParent(self)
    */
  }
  
  func stopAnimate() {
    hidden = true

    removeActionForKey(KeyForAction.engineAnimateAction)
    // engineEmitterNode.removeFromParent()
  }
}
