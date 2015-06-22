//
//  EndGameView.swift
//  SpaceUp
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class EndGameView: ModalView {
  let gameOverLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let scoreCaptionLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let scoreLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let topScoreCaptionLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let topScoreLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  let continueButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonPlayAgain)
  let quitButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonHome)
  let leaderboardButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonLeaderboard)
  let newLabel = SpriteButtonNode(imageNamed: TextureFileName.LabelNewScore)
  
  // MARK: - Init
  init() {
    super.init(size:  CGSize(width: 640, height: 920))
    
    // Game Over
    gameOverLabel.fontColor = UIColor(hexString: ColorHex.TextColor)
    gameOverLabel.position = CGPoint(x: modalBackground.frame.midX, y: modalBackground.frame.maxY - 180)
    gameOverLabel.fontSize = 80
    gameOverLabel.text = "GAME OVER"
    modal.addChild(gameOverLabel)
    
    // Recent score caption
    scoreCaptionLabel.color = UIColor(hexString: ColorHex.TextColor)
    scoreCaptionLabel.horizontalAlignmentMode = .Center
    scoreCaptionLabel.fontSize = 50
    scoreCaptionLabel.text = "SCORE"
    scoreCaptionLabel.position = CGPoint(x: modalBackground.frame.midX, y: gameOverLabel.frame.minY - 100)
    modal.addChild(scoreCaptionLabel)
    
    // Recent score
    scoreLabel.color = UIColor(hexString: ColorHex.TextColor)
    scoreLabel.horizontalAlignmentMode = .Center
    scoreLabel.fontSize = 50
    scoreLabel.position = CGPoint(x: modalBackground.frame.midX, y: scoreCaptionLabel.frame.minY - 60)
    modal.addChild(scoreLabel)
    
    // Top score caption
    topScoreCaptionLabel.color = UIColor(hexString: ColorHex.TextColor)
    topScoreCaptionLabel.horizontalAlignmentMode = .Center
    topScoreCaptionLabel.fontSize = 50
    topScoreCaptionLabel.text = "BEST"
    topScoreCaptionLabel.position = CGPoint(x: modalBackground.frame.midX, y: scoreLabel.frame.minY - 80)
    modal.addChild(topScoreCaptionLabel)
    
    // Top score
    topScoreLabel.color = UIColor(hexString: ColorHex.TextColor)
    topScoreLabel.colorBlendFactor = 1
    topScoreLabel.horizontalAlignmentMode = .Center
    topScoreLabel.fontSize = 50
    topScoreLabel.position = CGPoint(x: modalBackground.frame.midX, y: topScoreCaptionLabel.frame.minY - 60)
    modal.addChild(topScoreLabel)
    
    // Retry
    continueButton.position = CGPoint(x: modalBackground.frame.midX, y: modalBackground.frame.minY + 280)
    modal.addChild(continueButton)
    
    // Quit
    quitButton.position = CGPoint(x: modalBackground.frame.maxX - 130, y: modalBackground.frame.minY + 130)
    modal.addChild(quitButton)
    
    // Leaderboard
    leaderboardButton.position = CGPoint(x: modalBackground.frame.minX + 130, y: modalBackground.frame.minY + 130)
    modal.addChild(leaderboardButton)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Score
  func updateWithGameData(gameData: GameData, hasNewTopScore: Bool) {
    let numberFormatter = NSNumberFormatter()
    
    // Configure number formatter
    numberFormatter.maximumFractionDigits = 0
    numberFormatter.roundingMode = .RoundHalfUp
    
    topScoreLabel.text = numberFormatter.stringFromNumber(gameData.topScore) ?? "0"
    scoreLabel.text = numberFormatter.stringFromNumber(gameData.score) ?? "0"
    
    // Reposition
    if hasNewTopScore {
      newLabel.anchorPoint = CGPoint(x: 0.5, y: 0)
      newLabel.position = CGPoint(x: modalBackground.frame.midX - newLabel.frame.width / 2 - 10,
                                  y: topScoreCaptionLabel.position.y - 10)
      topScoreCaptionLabel.position = CGPoint(x: modalBackground.frame.midX + topScoreCaptionLabel.frame.width / 2 + 10,
                                              y: topScoreCaptionLabel.position.y)
      modal.addChildIfNeeded(newLabel)
    } else {
      newLabel.removeFromParentIfNeeded()
    }
  }
}
