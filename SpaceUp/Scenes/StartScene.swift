//
//  StartScene.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit
import StoreKit

class StartScene: SKScene, ButtonDelegate, SKProductsRequestDelegate {
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
    logo.anchorPoint = CGPoint(x: 0.5, y: 1)
    logo.position = CGPoint(x: screenFrame.midX, y: screenFrame.maxY - 60)
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
    storeButton.position = CGPoint(x: screenFrame.minX + 250, y: screenFrame.minY + 170)
    storeButton.delegate = self
    addChild(storeButton)
    
    // IAP
    requestProducts()
  }
  
  // MARK: - Update
  override func update(currentTime: NSTimeInterval) {
    backgroundPosition.y -= 1

    background.move(backgroundPosition, multiplier: 0.4)
    galaxyStars.move(backgroundPosition, multiplier: 0.7)
  }
  
  // MARK: - Appear
  func appear() {
    let startScale = CGPoint(x: 0.001, y: 0.001)
    let endScale = CGPoint(x: 1, y: 1)
    
    startButton.scaleAsPoint = startScale
    leaderboardButton.scaleAsPoint = startScale
    soundButton.scaleAsPoint = startScale
    storeButton.scaleAsPoint = startScale
    musicButton.scaleAsPoint = startScale
    
    let startButtonAction = SKTScaleEffect.scaleActionWithNode(startButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut)
    let leaderboardButtonAction = SKTScaleEffect.scaleActionWithNode(leaderboardButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut)
    let soundButtonAction = SKTScaleEffect.scaleActionWithNode(soundButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut)
    let storeButtonAction = SKTScaleEffect.scaleActionWithNode(storeButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut)
    let musicButtonAction = SKTScaleEffect.scaleActionWithNode(musicButton, duration: 1, startScale: startScale, endScale: endScale, timingFunction: SKTTimingFunctionBackEaseInOut)
    
    runAction(SKAction.group([
      startButtonAction,
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
  
  // MARK: - IAP
  func requestProducts() {
    let productIdentifiers = Set(["\(MainBundleIdentifier).RemoveAds"])
    let request = SKProductsRequest(productIdentifiers: productIdentifiers)
    
    request.delegate = self
    request.start()
  }
  
  // MARK: - SKProductsRequestDelegate
  func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
    println(response.products)
    println(response.invalidProductIdentifiers)

    if let products = response.products as? [SKProduct] {
      for product in products {
        println("\(product.productIdentifier) - \(product.price)")
      }
    }
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
      
    case storeButton:
      storeView = presentStore()
      storeView!.appear()

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
