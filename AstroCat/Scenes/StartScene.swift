//
//  StartScene.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class StartScene: SKScene, ButtonDelegate {
  // MARK: - Immutable var
  let startButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  let leaderboardButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  
  // MARK: - View
  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor.whiteColor()
    
    // Start button
    startButton.label.text = "Start Game"
    startButton.position = CGPoint(x: screenFrame.midX, y: screenFrame.midY)
    startButton.delegate = self
    addChild(startButton)
    
    // Leaderboard button
    leaderboardButton.label.text = "Leaderboard"
    leaderboardButton.position = CGPoint(x: screenFrame.midX, y: screenFrame.midY - 100)
    leaderboardButton.delegate = self
    addChild(leaderboardButton)
  }
  
  // MARK: - ButtonDelegate
  func touchBeganForButton(button: ButtonNode) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    switch button {
    case startButton:
      notificationCenter.postNotificationName(DidRequestStartGameNotification, object: self)
    
    case leaderboardButton:
      notificationCenter.postNotificationName(DidRequestLeaderboardNotification, object: self)
      
    default:
      break
    }
  }
}
