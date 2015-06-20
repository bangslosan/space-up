//
//  LoadingScene.swift
//  SpaceUp
//
//  Created by David Chin on 8/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class LoadingScene: SKScene {
  let loadingLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let background = BackgroundNode(imageNamed: TextureFileName.Background)
  let starFieldEmitter = SKEmitterNode(fileNamed: EffectFileName.StarField)
  
  lazy var dotAction: SKAction = {
    return SKAction.sequence([
      SKAction.waitForDuration(0.3),
      SKAction.runBlock { [weak self] in
        if let loadingLabel = self?.loadingLabel {
          if loadingLabel.text == "LOADING..." {
            loadingLabel.text = "LOADING"
          } else {
            loadingLabel.text = loadingLabel.text + "."
          }
        }
      }
    ])
  }()
  
  // MARK: - Init
  deinit {
    starFieldEmitter.targetNode = nil
  }

  // MARK: - View
  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor(hexString: ColorHex.BackgroundColor)

    // Background
    background.zPosition = -10
    addChild(background)
    
    starFieldEmitter.targetNode = background
    starFieldEmitter.position = CGPoint(x: background.frame.width / 2, y: background.frame.height / 2)
    background.addChild(starFieldEmitter)
    starFieldEmitter.advanceSimulationTime(20)
    
    // Label
    loadingLabel.color = UIColor(hexString: ColorHex.TextColor)
    loadingLabel.colorBlendFactor = 1
    loadingLabel.fontSize = 60
    loadingLabel.horizontalAlignmentMode = .Center
    loadingLabel.position = CGPoint(x: background.frame.midX, y: background.frame.midY)
    loadingLabel.text = "LOADING"
    addChild(loadingLabel)

    // Animate
    loadingLabel.runAction(SKAction.repeatActionForever(dotAction))
  }
}
