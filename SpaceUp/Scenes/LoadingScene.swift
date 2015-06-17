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
  
  // MARK: - Init
  deinit {
    starFieldEmitter.targetNode = nil
  }

  // MARK: - View
  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor(hexString: "#292656")

    // Background
    background.zPosition = -10
    addChild(background)
    
    starFieldEmitter.targetNode = background
    starFieldEmitter.position = CGPoint(x: background.frame.width / 2, y: background.frame.height / 2)
    background.addChild(starFieldEmitter)
    starFieldEmitter.advanceSimulationTime(20)
    
    // Label
    loadingLabel.color = UIColor(hexString: "#e0ebed")
    loadingLabel.colorBlendFactor = 1
    loadingLabel.fontSize = 60
    loadingLabel.horizontalAlignmentMode = .Center
    loadingLabel.position = CGPoint(x: background.frame.midX, y: background.frame.midY)
    loadingLabel.text = "LOADING..."
    addChild(loadingLabel)
  }
}
