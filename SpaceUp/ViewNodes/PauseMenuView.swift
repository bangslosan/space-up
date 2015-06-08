//
//  PauseMenuView.swift
//  SpaceUp
//
//  Created by David Chin on 26/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class PauseMenuView: SKNode {
  // MARK: - Immutable var
  let background: SKShapeNode
  let resumeButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  let quitButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  
  // MARK: - Init
  init(size: CGSize) {
    background = SKShapeNode(rectOfSize: size)

    super.init()
    
    // Config
    userInteractionEnabled = true
    
    // Background
    background.fillColor = UIColor(white: 0, alpha: 0.5)
    background.strokeColor = UIColor.clearColor()
    background.position = CGPoint(x: background.frame.width / 2, y: background.frame.height / 2)
    addChild(background)
    
    // Resume
    resumeButton.label.text = "Resume"
    resumeButton.position = CGPoint(x: background.frame.midX, y: background.frame.midY + 60)
    addChild(resumeButton)
    
    // Quit
    quitButton.label.text = "Quit"
    quitButton.position = CGPoint(x: background.frame.midX, y: background.frame.midY - 60)
    addChild(quitButton)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
