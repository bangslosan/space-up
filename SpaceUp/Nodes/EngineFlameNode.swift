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
  static let engineEndAnimateAction = "engineEndAnimateAction"
}

class EngineFlameNode: SKSpriteNode {
  // MARK: - Vars
  // private lazy var engineEmitterNode = SKEmitterNode(fileNamed: EffectFileName.Propel)

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
  
  private lazy var flameEndAnimateAction: SKAction = {
    return self.flameStartAnimateAction.reversedAction()
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
    removeActionForKey(KeyForAction.engineEndAnimateAction)
    runAction(SKAction.sequence([
      flameStartAnimateAction,
      flamePersistAnimateAction
    ]), withKey: KeyForAction.engineAnimateAction)
    
    // Emitter
    /*
    engineEmitterNode.zPosition = -1
    engineEmitterNode.position = CGPoint(x: 0, y: 30)
    engineEmitterNode.resetSimulation()
    engineEmitterNode.addToParent(self)
    */
  }
  
  func stopAnimate() {
    removeActionForKey(KeyForAction.engineAnimateAction)
    runAction(SKAction.sequence([
      flameEndAnimateAction,
      SKAction.runBlock { [weak self] in
        self?.hidden = true
      }
    ]), withKey: KeyForAction.engineEndAnimateAction)
  }
}
