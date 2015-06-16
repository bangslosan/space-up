//
//  StartScene.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class StartScene: SKScene, ButtonDelegate {
  // MARK: - Vars
  weak var startSceneDelegate: StartSceneDelegate?

  // MARK: - Immutable var
  let textureAtlases = [SKTextureAtlas(named: TextureAtlasFileName.UserInterface)]
  // let background = BackgroundNode(imageNamed: TextureFileName.StartBackground)
  let starFieldEmitter = SKEmitterNode(fileNamed: EffectFileName.StarField)
  let background = SKShapeNode(rectOfSize: SceneSize)
  let logo = SKSpriteNode(imageNamed: TextureFileName.StartLogo)
  let startButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonPlay)
  let leaderboardButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonLeaderboard)
  let soundButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonSound)
  let musicButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonMusic)
  let adButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonAd)
  
  // MARK: - Init
  override init(size: CGSize) {
    super.init(size: size)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    starFieldEmitter.targetNode = nil
  }
  
  // MARK: - View
  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor(hexString: "#212157")

    // Background
    background.strokeColor = UIColor.clearColor()
    background.position = CGPoint(x: background.frame.width / 2, y: background.frame.height / 2)
    background.zPosition = -10
    addChild(background)
    
    starFieldEmitter.targetNode = background
    background.addChild(starFieldEmitter)
    starFieldEmitter.advanceSimulationTime(20)
    
    // Logo
    logo.anchorPoint = CGPoint(x: 0.5, y: 1)
    logo.position = CGPoint(x: background.frame.midX, y: background.frame.maxY - 60)
    addChild(logo)
    
    // Start button
    startButton.position = CGPoint(x: logo.frame.midX, y: logo.frame.minY - 100)
    startButton.delegate = self
    addChild(startButton)
    
    // Leaderboard button
    leaderboardButton.position = CGPoint(x: screenFrame.minX + 100, y: startButton.frame.midY - 40)
    leaderboardButton.delegate = self
    addChild(leaderboardButton)
    
    // Music button
    musicButton.position = CGPoint(x: screenFrame.maxX - 100, y: startButton.frame.midY - 40)
    musicButton.setTexture(SKTexture(imageNamed: TextureFileName.ButtonMusicOff), forState: .Active)
    musicButton.state = isMusicEnabled() ? .Normal : .Active
    musicButton.delegate = self
    addChild(musicButton)
    
    // Sound button
    soundButton.position = CGPoint(x: screenFrame.maxX - 250, y: screenFrame.minY + 170)
    soundButton.setTexture(SKTexture(imageNamed: TextureFileName.ButtonSoundOff), forState: .Active)
    soundButton.state = isSoundEnabled() ? .Normal : .Active
    soundButton.delegate = self
    addChild(soundButton)
    
    // Ad button
    adButton.position = CGPoint(x: screenFrame.minX + 250, y: screenFrame.minY + 170)
    adButton.delegate = self
    addChild(adButton)
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
      startSceneDelegate?.startSceneDidRequestToggleSound?(self, withButton: soundButton)
      
    case musicButton:
      startSceneDelegate?.startSceneDidRequestToggleMusic?(self, withButton: musicButton)
      
    default:
      break
    }
  }
}
