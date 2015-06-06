//
//  PauseMenuView.swift
//  AstroCat
//
//  Created by David Chin on 26/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class PauseMenuView: SKShapeNode {
  // MARK: - Immutable var
  let resumeButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  let quitButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  
  // MARK: - Init
  init(rect: CGRect) {
    super.init()
    
    // Shape
    path = CGPathCreateWithRect(rect, nil)
    fillColor = UIColor(white: 0, alpha: 0.5)
    strokeColor = UIColor.clearColor()
    
    // Config
    userInteractionEnabled = true
    
    // Resume
    resumeButton.label.text = "Resume"
    resumeButton.position = CGPoint(x: frame.midX, y: frame.midY + 60)
    addChild(resumeButton)
    
    // Quit
    quitButton.label.text = "Quit"
    quitButton.position = CGPoint(x: frame.midX, y: frame.midY - 60)
    addChild(quitButton)
  }
  
  convenience init(size: CGSize) {
    self.init(rect: CGRect(origin: CGPointZero, size: size))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
