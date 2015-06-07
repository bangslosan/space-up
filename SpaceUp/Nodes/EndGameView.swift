//
//  EndGameView.swift
//  SpaceUp
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class EndGameView: SKNode {
  let background: SKShapeNode
  let scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue")
  let topScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue")
  let continueButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  let quitButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  
  // MARK: - Init
  init(size: CGSize) {
    background = SKShapeNode(rectOfSize: size)

    super.init()
    
    // Background
    background.fillColor = UIColor(white: 255, alpha: 0.5)
    background.strokeColor = UIColor.clearColor()
    background.position = CGPoint(x: background.frame.width / 2, y: background.frame.height / 2)
    addChild(background)
    
    // Recent score
    scoreLabel.color = UIColor.lightGrayColor()
    scoreLabel.colorBlendFactor = 1
    scoreLabel.horizontalAlignmentMode = .Center
    scoreLabel.position = CGPoint(x: background.frame.midX, y: background.frame.maxY - 130)
    addChild(scoreLabel)
    
    // Top score
    topScoreLabel.color = UIColor.magentaColor()
    topScoreLabel.colorBlendFactor = 1
    topScoreLabel.horizontalAlignmentMode = .Center
    topScoreLabel.position = CGPoint(x: background.frame.midX, y: background.frame.maxY - 180)
    addChild(topScoreLabel)
    
    // Retry
    continueButton.label.text = "Continue"
    continueButton.position = CGPoint(x: background.frame.midX, y: background.frame.maxY - 300)
    addChild(continueButton)
    
    // Quit
    quitButton.label.text = "Quit"
    quitButton.position = CGPoint(x: background.frame.midX, y: background.frame.maxY - 400)
    addChild(quitButton)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Score
  func updateWithGameData(gameData: GameData) {
    let numberFormatter = NSNumberFormatter()
    
    // Configure number formatter
    numberFormatter.maximumFractionDigits = 0
    numberFormatter.roundingMode = .RoundHalfUp
    
    topScoreLabel.text = numberFormatter.stringFromNumber(gameData.topScore) ?? "0"
    scoreLabel.text = numberFormatter.stringFromNumber(gameData.score) ?? "0"
  }
}
