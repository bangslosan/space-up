//
//  HUDNode.swift
//  SpaceUp
//
//  Created by David Chin on 24/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class HUDNode: SKNode {
  // MARK: - Immutable var
  let scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue")
  let topScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue")
  
  // MARK: - Init
  override init() {
    super.init()
    
    // Score
    topScoreLabel.color = UIColor.magentaColor()
    topScoreLabel.colorBlendFactor = 1
    topScoreLabel.horizontalAlignmentMode = .Left
    topScoreLabel.position = CGPoint(x: 20, y: -50)
    addChild(topScoreLabel)

    scoreLabel.color = UIColor.lightGrayColor()
    scoreLabel.colorBlendFactor = 1
    scoreLabel.horizontalAlignmentMode = .Left
    scoreLabel.position = CGPoint(x: 20, y: -100)
    addChild(scoreLabel)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Data
  func updateWithGameData(gameData: GameData) {
    let numberFormatter = NSNumberFormatter()
    
    // Configure number formatter
    numberFormatter.maximumFractionDigits = 0
    numberFormatter.roundingMode = .RoundHalfUp
    
    topScoreLabel.text = numberFormatter.stringFromNumber(gameData.topScore) ?? "0"
    scoreLabel.text = numberFormatter.stringFromNumber(gameData.score) ?? "0"
  }
}
