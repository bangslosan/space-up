//
//  ShadowLabelNode.swift
//  SpaceUp
//
//  Created by David Chin on 14/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class ShadowLabelNode: SKLabelNode {
  private let effectLabel = SKLabelNode()

  // MARK: - Init
  override init(fontNamed fontName: String?) {
    super.init(fontNamed: fontName)
    
    // Effect
    effectLabel.position = CGPoint(x: 6, y: -6)
    effectLabel.alpha = 0.3
    effectLabel.colorBlendFactor = 1
    effectLabel.color = UIColor.blackColor()
    addChild(effectLabel)
    
    // KVO
    addObserver(self, forKeyPath: "text", options: .New, context: nil)
  }
  
  override init() {
    super.init()
  }
  
  deinit {
    removeObserver(self, forKeyPath: "text")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - KVO
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if keyPath == "text" {
      effectLabel.fontSize = fontSize
      effectLabel.fontName = fontName
      effectLabel.verticalAlignmentMode = verticalAlignmentMode
      effectLabel.horizontalAlignmentMode = horizontalAlignmentMode
      effectLabel.text = text
    }
  }
}
