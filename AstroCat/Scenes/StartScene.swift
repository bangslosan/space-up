//
//  StartScene.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class StartScene: SKScene, ButtonDelegate {
  // MARK: - Vars
  weak var startSceneDelegate: StartSceneDelegate?

  // MARK: - Immutable var
  let startButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  let leaderboardButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  let soundButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  let musicButton = TextButtonNode(size: CGSize(width: 300, height: 60))
  
  // MARK: - View
  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor.whiteColor()
    
    // Start button
    startButton.label.text = "Start Game"
    startButton.position = CGPoint(x: screenFrame.midX, y: screenFrame.midY + 100)
    startButton.delegate = self
    addChild(startButton)
    
    // Leaderboard button
    leaderboardButton.label.text = "Leaderboard"
    leaderboardButton.position = CGPoint(x: screenFrame.midX, y: screenFrame.midY)
    leaderboardButton.delegate = self
    addChild(leaderboardButton)
    
    // Sound button
    soundButton.label.text = isSoundEnabled() ? "Sound On" : "Sound Off"
    soundButton.position = CGPoint(x: screenFrame.midX, y: screenFrame.midY - 100)
    soundButton.delegate = self
    addChild(soundButton)
    
    // Music button
    musicButton.label.text = isMusicEnabled() ? "Music On" : "Music Off"
    musicButton.position = CGPoint(x: screenFrame.midX, y: screenFrame.midY - 200)
    musicButton.delegate = self
    addChild(musicButton)
  }
  
  // MARK: - ButtonDelegate
  func touchBeganForButton(button: ButtonNode) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    switch button {
    case startButton:
      startSceneDelegate?.startSceneDidRequestStart?(self)
    
    case leaderboardButton:
      startSceneDelegate?.startSceneDidRequestLeaderboard?(self)
      
    case soundButton:
      toggleSound()
      
    case musicButton:
      toggleMusic()
      
    default:
      break
    }
  }
  
  // MARK: - Sound
  func toggleSound() {
    let userDefaults = NSUserDefaults.standardUserDefaults()

    if isSoundEnabled() {
      userDefaults.setValue(true, forKey: KeyForUserDefaults.SoundDisabled)
      soundButton.label.text = "Sound Off"
    } else {
      userDefaults.setValue(false, forKey: KeyForUserDefaults.SoundDisabled)
      soundButton.label.text = "Sound On"
    }
    
    userDefaults.synchronize()
  }
  
  func toggleMusic() {
    let userDefaults = NSUserDefaults.standardUserDefaults()

    if isMusicEnabled() {
      userDefaults.setValue(true, forKey: KeyForUserDefaults.MusicDisabled)
      musicButton.label.text = "Music Off"
    } else {
      userDefaults.setValue(false, forKey: KeyForUserDefaults.MusicDisabled)
      musicButton.label.text = "Music On"
    }
    
    userDefaults.synchronize()
  }
}
