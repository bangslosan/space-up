//
//  LoadingScene.swift
//  SpaceUp
//
//  Created by David Chin on 8/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class LoadingScene: SKScene {
  let loadingLabel = SKLabelNode(fontNamed: "HelveticaNeue")
  let background: SKSpriteNode
  
  override init(size: CGSize) {
    background = SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: size)

    super.init(size: size)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View
  override func didMoveToView(view: SKView) {
    // Background
    background.anchorPoint = CGPointZero
    addChild(background)
    
    // Label
    loadingLabel.color = UIColor.whiteColor()
    loadingLabel.colorBlendFactor = 1
    loadingLabel.horizontalAlignmentMode = .Center
    loadingLabel.position = CGPoint(x: background.frame.midX, y: background.frame.midY)
    loadingLabel.text = "Loading..."
    addChild(loadingLabel)
  }
}
