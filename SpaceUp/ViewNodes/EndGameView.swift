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
  let modalBackground = ModalBackgroundNode(size: CGSize(width: 640, height: 920))
  let gameOverLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let scoreCaptionLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let scoreLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let topScoreCaptionLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let topScoreLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let continueButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonPlayAgain)
  let quitButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonHome)
  let leaderboardButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonLeaderboard)
  
  // MARK: - Init
  init(size: CGSize) {
    background = SKShapeNode(rectOfSize: size)

    super.init()
    
    // Background
    background.fillColor = UIColor(white: 0, alpha: 0.5)
    background.strokeColor = UIColor.clearColor()
    background.position = CGPoint(x: background.frame.width / 2, y: background.frame.height / 2)
    background.userInteractionEnabled = false
    background.zPosition = -1
    addChild(background)
    
    // Modal background
    modalBackground.position = CGPoint(x: background.frame.midX, y: background.frame.midY)
    modalBackground.userInteractionEnabled = false
    modalBackground.zPosition = -1
    addChild(modalBackground)
    
    // Game Over
    gameOverLabel.fontColor = UIColor(hexString: "#e0ebed")
    gameOverLabel.position = CGPoint(x: modalBackground.frame.midX, y: modalBackground.frame.maxY - 180)
    gameOverLabel.fontSize = 80
    gameOverLabel.text = "GAME OVER"
    addChild(gameOverLabel)
    
    // Recent score caption
    scoreCaptionLabel.color = UIColor(hexString: "#e0ebed")
    scoreCaptionLabel.horizontalAlignmentMode = .Center
    scoreCaptionLabel.fontSize = 50
    scoreCaptionLabel.text = "SCORE"
    scoreCaptionLabel.position = CGPoint(x: modalBackground.frame.midX, y: gameOverLabel.frame.minY - 100)
    addChild(scoreCaptionLabel)
    
    // Recent score
    scoreLabel.color = UIColor(hexString: "#e0ebed")
    scoreLabel.horizontalAlignmentMode = .Center
    scoreLabel.fontSize = 50
    scoreLabel.position = CGPoint(x: modalBackground.frame.midX, y: scoreCaptionLabel.frame.minY - 60)
    addChild(scoreLabel)
    
    // Top score caption
    topScoreCaptionLabel.color = UIColor(hexString: "#e0ebed")
    topScoreCaptionLabel.horizontalAlignmentMode = .Center
    topScoreCaptionLabel.fontSize = 50
    topScoreCaptionLabel.text = "BEST"
    topScoreCaptionLabel.position = CGPoint(x: modalBackground.frame.midX, y: scoreLabel.frame.minY - 80)
    addChild(topScoreCaptionLabel)
    
    // Top score
    topScoreLabel.color = UIColor(hexString: "#e0ebed")
    topScoreLabel.colorBlendFactor = 1
    topScoreLabel.horizontalAlignmentMode = .Center
    topScoreLabel.fontSize = 50
    topScoreLabel.position = CGPoint(x: modalBackground.frame.midX, y: topScoreCaptionLabel.frame.minY - 60)
    addChild(topScoreLabel)
    
    // Retry
    continueButton.position = CGPoint(x: modalBackground.frame.midX, y: modalBackground.frame.minY + 280)
    addChild(continueButton)
    
    // Quit
    quitButton.position = CGPoint(x: modalBackground.frame.maxX - 130, y: modalBackground.frame.minY + 130)
    addChild(quitButton)
    
    // Leaderboard
    leaderboardButton.position = CGPoint(x: modalBackground.frame.minX + 130, y: modalBackground.frame.minY + 130)
    addChild(leaderboardButton)
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
