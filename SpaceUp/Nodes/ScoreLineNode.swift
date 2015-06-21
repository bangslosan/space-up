//
//  ScoreLineNode.swift
//  SpaceUp
//
//  Created by David Chin on 11/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class ScoreLineNode: SKNode {
  private let line: SKShapeNode
  private let scoreLabel = SKLabelNode(fontNamed: FontName.RegularFont)

  init(length: CGFloat) {
    line = SKShapeNode(rect: CGRect(x: 0, y: 0, width: length, height: 1))

    super.init()
    
    // Line
    line.fillColor = UIColor.whiteColor()
    line.strokeColor = UIColor.clearColor()
    addChild(line)
    
    // Label
    scoreLabel.color = UIColor.whiteColor()
    scoreLabel.colorBlendFactor = 1
    scoreLabel.horizontalAlignmentMode = .Center
    scoreLabel.position = CGPoint(x: line.frame.width / 2, y: 30)
    scoreLabel.fontSize = 20
    scoreLabel.text = "Top Score"
    addChild(scoreLabel)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Score
  func updateWithScore(score: CGFloat, forPlayer player: PlayerNode) {
    let distance = GameData.transformScoreToDistance(score)
    let y = (player.initialPosition?.y ?? 0) + distance
    
    position = CGPoint(x: 0, y: y)
    hidden = score <= 10
  }
}
