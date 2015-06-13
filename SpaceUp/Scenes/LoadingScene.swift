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
  let background = BackgroundNode(imageNamed: TextureFileName.StartBackground)

  // MARK: - View
  override func didMoveToView(view: SKView) {
    // Background
    addChild(background)
    
    // Label
    loadingLabel.color = UIColor(hexString: "#e0ebed")
    loadingLabel.colorBlendFactor = 1
    loadingLabel.fontSize = 60
    loadingLabel.horizontalAlignmentMode = .Center
    loadingLabel.position = CGPoint(x: background.frame.midX, y: background.frame.midY)
    loadingLabel.text = "Loading..."
    addChild(loadingLabel)
  }
}
