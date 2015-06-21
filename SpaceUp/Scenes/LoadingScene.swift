//
//  LoadingScene.swift
//  SpaceUp
//
//  Created by David Chin on 8/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class LoadingScene: SKScene {
  // MARK: - Vars
  var backgroundPosition = CGPointZero

  // MARK: - Immutable var
  let loadingLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let background = EndlessBackgroundNode(imageNames: [TextureFileName.Background])
  let galaxyStars = EndlessBackgroundNode(imageNames: [TextureFileName.BackgroundStars])
  
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
  
  // MARK: - Update
  override func update(currentTime: NSTimeInterval) {
    backgroundPosition.y -= 1
    
    background.move(backgroundPosition, multiplier: 0.4)
    galaxyStars.move(backgroundPosition, multiplier: 0.7)
  }

  // MARK: - View
  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor(hexString: ColorHex.BackgroundColor)

    // Background
    addChild(background)
    addChild(galaxyStars)
    
    // Label
    loadingLabel.color = UIColor(hexString: ColorHex.TextColor)
    loadingLabel.colorBlendFactor = 1
    loadingLabel.fontSize = 60
    loadingLabel.horizontalAlignmentMode = .Center
    loadingLabel.position = CGPoint(x: screenFrame.midX, y: screenFrame.midY)
    loadingLabel.text = "LOADING"
    addChild(loadingLabel)

    // Animate
    loadingLabel.runAction(SKAction.repeatActionForever(dotAction))
  }
}
