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
  // MARK: - Immutable vars
  private let textureAtlas = SKTextureAtlas(named: TextureAtlasFileName.Character)
  
  // MARK: - Vars
  private lazy var flameStartAnimateAction: SKAction = {
    return SKAction.animateWithTextures([
      self.textureAtlas.textureNamed(TextureFileName.EngineFlame + "1"),
      self.textureAtlas.textureNamed(TextureFileName.EngineFlame + "2"),
      self.textureAtlas.textureNamed(TextureFileName.EngineFlame + "3"),
      self.textureAtlas.textureNamed(TextureFileName.EngineFlame + "4"),
      self.textureAtlas.textureNamed(TextureFileName.EngineFlame + "5"),
      self.textureAtlas.textureNamed(TextureFileName.EngineFlame + "6")
    ], timePerFrame: 1/20)
  }()
  
  private lazy var flamePersistAnimateAction: SKAction = {
    return SKAction.repeatActionForever(SKAction.animateWithTextures([
      self.textureAtlas.textureNamed(TextureFileName.EngineFlame + "5"),
      self.textureAtlas.textureNamed(TextureFileName.EngineFlame + "6")
    ], timePerFrame: 1/20))
  }()

  // MARK: - Init
  init() {
    let texture = textureAtlas.textureNamed(TextureFileName.EngineFlame + "1")

    super.init(texture: texture, color: nil, size: texture.size())
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Animate
  func animate() {
    let action = SKAction.sequence([
      flameStartAnimateAction,
      flamePersistAnimateAction
    ])

    hidden = false

    runAction(action, withKey: KeyForAction.engineAnimateAction)
  }
  
  func stopAnimate() {
    hidden = true

    removeActionForKey(KeyForAction.engineAnimateAction)
  }
}
