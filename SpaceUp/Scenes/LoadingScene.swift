//
//  LoadingScene.swift
//  SpaceUp
//
//  Created by David Chin on 8/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let loadingAnimateAction = "loadingAnimateAction"
}

class LoadingScene: SKScene {
  // MARK: - Immutable vars
  var type: LoadingSceneType

  // MARK: - Vars
  lazy var backgroundPosition = CGPointZero
  lazy var loadingLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  lazy var background = EndlessBackgroundNode(imageNames: [TextureFileName.Background])
  lazy var galaxyStars = EndlessBackgroundNode(imageNames: [TextureFileName.BackgroundStars])
  
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
  init(size: CGSize, type: LoadingSceneType) {
    self.type = type

    super.init(size: size)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Update
  override func update(currentTime: NSTimeInterval) {
    if type == .Regular {
      backgroundPosition.y -= 1
      
      background.move(backgroundPosition, multiplier: 0.4)
      galaxyStars.move(backgroundPosition, multiplier: 0.7)
    }
  }

  // MARK: - View
  override func didMoveToView(view: SKView) {
    if type == .Regular {
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
      loadingLabel.runAction(SKAction.repeatActionForever(dotAction), withKey: KeyForAction.loadingAnimateAction)
    } else {
      backgroundColor = UIColor(white: 0, alpha: 1)
    }
  }
}
