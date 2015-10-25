//
//  StartScene.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class StartScene: SKScene, ButtonDelegate {
  // MARK: - Immutable var
  let background = EndlessBackgroundNode(imageNames: [TextureFileName.Background])
  let galaxyStars = EndlessBackgroundNode(imageNames: [TextureFileName.BackgroundStars])
  let logo = SKSpriteNode(imageNamed: TextureFileName.StartLogo)
  let startButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonPlay)
  let leaderboardButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonLeaderboard)
  let soundButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonSound)
  let musicButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonMusic)
  let storeButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonAd)

  // MARK: - Vars
  weak var startSceneDelegate: StartSceneDelegate?
  var backgroundPosition = CGPointZero
  var storeView: StoreView?
  var textureAtlases: [SKTextureAtlas]?
  var textures: [SKTexture]?
  
  // MARK: - Init
  override init(size: CGSize) {
    super.init(size: size)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View
  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor(hexString: ColorHex.BackgroundColor)

    // Background
    addChild(background)
    addChild(galaxyStars)
    
    // Logo
    logo.anchorPoint = CGPoint(x: 0.5, y: 0)
    logo.position = CGPoint(x: screenFrame.midX, y: screenFrame.midY - 140)
    addChild(logo)
    
    // Start button
    startButton.position = CGPoint(x: logo.frame.midX, y: logo.frame.minY - 90)
    startButton.delegate = self
    addChild(startButton)
    
    // Leaderboard button
    leaderboardButton.delegate = self
    addChild(leaderboardButton)
    
    // Music button
    musicButton.setTexture(SKTexture(imageNamed: TextureFileName.ButtonMusicOff), forState: .Active)
    musicButton.state = isMusicEnabled() ? .Normal : .Active
    musicButton.delegate = self
    addChild(musicButton)
    
    // Sound button
    soundButton.setTexture(SKTexture(imageNamed: TextureFileName.ButtonSoundOff), forState: .Active)
    soundButton.state = isSoundEnabled() ? .Normal : .Active
    soundButton.delegate = self
    addChild(soundButton)
    
    // Ad button
    storeButton.delegate = self
    addChild(storeButton)
    
    // Layout
    updateLayout()
    
    // Notification
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: "paymentTransactionDidComplete:", name: PaymentTransactionDidCompleteNotification, object: nil)
    notificationCenter.addObserver(self, selector: "paymentTransactionDidRestore:", name: PaymentTransactionDidRestoreNotification, object: nil)
  }
  
  override func willMoveFromView(view: SKView) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.removeObserver(self)
  }
  
  // MARK: - Update
  override func update(currentTime: NSTimeInterval) {
    backgroundPosition.y -= 1

    background.move(backgroundPosition, multiplier: 0.4)
    galaxyStars.move(backgroundPosition, multiplier: 0.7)
  }
  
  // MARK: - Layout
  func updateLayout() {
    let screenBounds = UIScreen.mainScreen().nativeBounds
    var offset = CGPointZero
    
    if screenBounds.height > 960 {
      offset = CGPoint(x: 10, y: 30)
    }

    if isAdsEnabled() {
      leaderboardButton.position = CGPoint(x: startButton.frame.midX - (240 + offset.x),
                                           y: startButton.frame.midY - (45 + offset.y))
      musicButton.position = CGPoint(x: startButton.frame.midX + (240 + offset.x),
                                     y: startButton.frame.midY - (45 + offset.y))
      soundButton.position = CGPoint(x: startButton.frame.midX + 110,
                                     y: startButton.frame.midY - (200 + offset.y))
      storeButton.position = CGPoint(x: startButton.frame.midX - 110,
                                     y: startButton.frame.midY - (200 + offset.y))
      
      addChildIfNeeded(storeButton)
    } else {
      leaderboardButton.position = CGPoint(x: startButton.frame.midX - (220 + offset.x),
                                           y: startButton.frame.midY - (80 + offset.y))
      musicButton.position = CGPoint(x: startButton.frame.midX + (220 + offset.x),
                                     y: startButton.frame.midY - (80 + offset.y))
      soundButton.position = CGPoint(x: startButton.frame.midX,
                                     y: startButton.frame.midY - (200 + offset.y))
    
      storeButton.removeFromParentIfNeeded()
    }
  }
  
  // MARK: - Appear
  func appear() {
    let startScale = CGPoint(x: 0.0001, y: 0.0001)
    let endScale = CGPoint(x: 1, y: 1)
    
    startButton.scaleAsPoint = startScale
    leaderboardButton.scaleAsPoint = startScale
    soundButton.scaleAsPoint = startScale
    storeButton.scaleAsPoint = startScale
    musicButton.scaleAsPoint = startScale
    
    let startButtonAction = SKAction.group([
      SKTScaleEffect.scaleActionWithNode(startButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut),
      SKTAlphaEffect.alphaActionWithNode(startButton, duration: 1, startAlpha: 0, endAlpha: 1, timingFunction: SKTTimingFunctionBackEaseInOut)
    ])

    let leaderboardButtonAction = SKAction.group([
      SKTScaleEffect.scaleActionWithNode(leaderboardButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut),
      SKTAlphaEffect.alphaActionWithNode(leaderboardButton, duration: 1, startAlpha: 0, endAlpha: 1, timingFunction: SKTTimingFunctionBackEaseInOut)
    ])

    let soundButtonAction = SKAction.group([
      SKTScaleEffect.scaleActionWithNode(soundButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut),
      SKTAlphaEffect.alphaActionWithNode(soundButton, duration: 1, startAlpha: 0, endAlpha: 1, timingFunction: SKTTimingFunctionBackEaseInOut)
    ])

    let storeButtonAction = SKAction.group([
      SKTScaleEffect.scaleActionWithNode(storeButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut),
      SKTAlphaEffect.alphaActionWithNode(storeButton, duration: 1, startAlpha: 0, endAlpha: 1, timingFunction: SKTTimingFunctionBackEaseInOut)
    ])

    let musicButtonAction = SKAction.group([
      SKTScaleEffect.scaleActionWithNode(musicButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut),
      SKTAlphaEffect.alphaActionWithNode(musicButton, duration: 1, startAlpha: 0, endAlpha: 1, timingFunction: SKTTimingFunctionBackEaseInOut)
    ])
    
    runAction(SKAction.group([
      SKAction.afterDelay(0, performAction: startButtonAction),
      SKAction.afterDelay(0.1, performAction: leaderboardButtonAction),
      SKAction.afterDelay(0.2, performAction: storeButtonAction),
      SKAction.afterDelay(0.3, performAction: soundButtonAction),
      SKAction.afterDelay(0.4, performAction: musicButtonAction)
    ]))
  }
  
  // MARK: - Store
  func presentStore() -> StoreView {
    let storeView = StoreView()
    
    storeView.closeButton.delegate = self
    
    addChild(storeView)
    
    return storeView
  }
  
  // MARK: - Notification
  func paymentTransactionDidComplete(notification: NSNotification) {
    updateLayout()
  }
  
  func paymentTransactionDidRestore(notification: NSNotification) {
    updateLayout()
  }
  
  // MARK: - ButtonDelegate
  func touchBeganForButton(button: ButtonNode) {
    switch button {
    case startButton:
      startSceneDelegate?.startSceneDidRequestStart?(self)
    
    case leaderboardButton:
      startSceneDelegate?.startSceneDidRequestLeaderboard?(self)
      
    case soundButton:
      startSceneDelegate?.startSceneDidRequestToggleSound?(self, withButton: soundButton)
      
    case musicButton:
      startSceneDelegate?.startSceneDidRequestToggleMusic?(self, withButton: musicButton)
      
    case storeButton:
      startSceneDelegate?.startSceneDidRequestStore?(self)
      
    default:
      if button == storeView?.closeButton {
        storeView?.disappear() {
          self.storeView?.removeFromParent()
        }
      }

      break
    }
  }
}
