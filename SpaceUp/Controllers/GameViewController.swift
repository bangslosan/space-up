//
//  GameViewController.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit
import GameKit
import iAd
import StoreKit

// TODO: Refactor, too many responsbilities atm
class GameViewController: UIViewController, GKGameCenterControllerDelegate, ADInterstitialAdDelegate, GameCenterManagerDelegate, GameSceneDelegate, StartSceneDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
  // MARK: - Immutable vars
  let gameCenterManager = GameCenterManager()
  let gameData = GameData.dataFromArchive()
  
  // MARK: - Vars
  private var interstitialAdView: InterstitialAdView?
  private var interstitialAd: ADInterstitialAd?
  private var numberOfRetriesSinceLastAd: UInt = 0
  private var products: [SKProduct]?
  private var removeAdsProduct: SKProduct?

  // MARK: - Computed vars
  var skView: SKView! {
    return view as? SKView
  }
  
  // MARK: - View
  override func loadView() {
    super.loadView()

    view = SKView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // iAd
    interstitialPresentationPolicy = .Manual
    
    // Configure the view.
    // skView.showsFPS = true
    // skView.showsNodeCount = true
    // skView.showsPhysics = true
    skView.ignoresSiblingOrder = true
    
    // Present scene
    presentStartScene()
    
    // GameCenter
    gameCenterManager.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    LoadingIndicatorView.sharedView.showInView(view)
    
    gameCenterManager.authenticateLocalPlayer()
  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  // MARK: - Scene
  func presentStartScene() -> StartScene {
    let scene = StartScene(size: SceneSize)
    scene.scaleMode = .AspectFill
    scene.startSceneDelegate = self
    
    // Present scene
    skView.presentScene(scene)
    skView.paused = false
    scene.appear()
    
    // Background music
    SKTAudio.sharedInstance().pauseBackgroundMusic()
    
    return scene
  }
  
  func presentGameScene() -> GameScene {
    let scene = GameScene(size: SceneSize, gameData: gameData)
    scene.scaleMode = .AspectFill
    scene.gameSceneDelegate = self
    
    // Present scene
    skView.presentScene(scene)
    skView.paused = false
    
    // Background music
    if isMusicEnabled() {
      SKTAudio.sharedInstance().playBackgroundMusic(SoundFileName.BackgroundMusic)
    } else {
      SKTAudio.sharedInstance().pauseBackgroundMusic()
    }
    
    return scene
  }
  
  func preloadAndPresentStartScene(completion: ((StartScene) -> Void)? = nil) {
    let textureAtlases: [SKTextureAtlas] = [
      SKTextureAtlas(named: TextureAtlasFileName.UserInterface)
    ]
    
    let textures: [SKTexture] = [
      SKTexture(imageNamed: TextureFileName.Background),
      SKTexture(imageNamed: TextureFileName.BackgroundStars),
      SKTexture(imageNamed: TextureFileName.StartLogo)
    ]
    
    // Show loading scene
    presentLoadingScene()
    
    // Preload textures
    preloadTextures(textures, textureAtlases) { [weak self] in
      // Present game scene
      if let scene = self?.presentStartScene() {
        // Retain preloaded textures
        scene.textureAtlases = textureAtlases
        scene.textures = textures
        
        completion?(scene)
      }
    }
  }
  
  func preloadAndPresentGameScene(completion: ((GameScene) -> Void)? = nil) {
    let textureAtlases: [SKTextureAtlas] = [
      SKTextureAtlas(named: TextureAtlasFileName.Environment),
      SKTextureAtlas(named: TextureAtlasFileName.Character),
      SKTextureAtlas(named: TextureAtlasFileName.UserInterface)
    ]
    
    let textures: [SKTexture] = [
      SKTexture(imageNamed: TextureFileName.Background),
      SKTexture(imageNamed: TextureFileName.BackgroundSmallPlanets),
      SKTexture(imageNamed: TextureFileName.BackgroundSmallPlanets + "2"),
      SKTexture(imageNamed: TextureFileName.BackgroundLargePlanets),
      SKTexture(imageNamed: TextureFileName.BackgroundLargePlanets + "2"),
      SKTexture(imageNamed: TextureFileName.BackgroundStars),
      SKTexture(imageNamed: TextureFileName.PlanetGround)
    ]
    
    // Show loading scene
    presentLoadingScene()

    // Preload textures
    preloadTextures(textures, textureAtlases) { [weak self] in
      // Present game scene
      if let scene = self?.presentGameScene() {
        // Retain preloaded textures
        scene.textureAtlases = textureAtlases
        scene.textures = textures
        
        completion?(scene)
      }
    }
  }
  
  func presentLoadingScene() -> LoadingScene {
    let scene = LoadingScene(size: SceneSize)
    scene.scaleMode = .AspectFill
    
    // Present scene
    skView.presentScene(scene)
    skView.paused = false
    
    // Background music
    SKTAudio.sharedInstance().pauseBackgroundMusic()
    
    return scene
  }
  
  // MARK: - Leaderboard
  func presentLeaderboard() {
    if let leaderboardIdentifier = gameCenterManager.leaderboardIdentifier where gameCenterManager.isAuthenticated {
      presentLeaderboardViewControllerWithIdentifier(leaderboardIdentifier)
    } else {
      let message = "Please log into GameCenter to access the leaderboard"
      let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
      let cancelAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
      let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { _ in
        self.gameCenterManager.promptLocalPlayerAuthentication()
      }
      
      alertController.addAction(okAlertAction)
      alertController.addAction(cancelAlertAction)
      
      presentViewController(alertController, animated: true, completion: nil)
    }
  }

  func presentLeaderboardViewControllerWithIdentifier(identifier: String) -> GKGameCenterViewController {
    let leaderboardViewController = GKGameCenterViewController()
    
    leaderboardViewController.gameCenterDelegate = self
    leaderboardViewController.viewState = .Leaderboards
    leaderboardViewController.leaderboardIdentifier = identifier
    
    skView.paused = true

    presentViewController(leaderboardViewController, animated: true, completion: nil)
    
    return leaderboardViewController
  }
  
  // MARK: - Ad
  func prepareInterstitialAd() {
    interstitialAd = ADInterstitialAd()
    interstitialAd!.delegate = self
  }

  func presentInterstitialAd() -> Bool {
    if isAdsEnabled() == false {
      println("Ads are disabled")
      
      return false
    } else if interstitialAd?.loaded != true {
      println("Ad not loaded")
      
      return false
    }

    // Container view
    interstitialAdView = InterstitialAdView(frame: skView.bounds)
    interstitialAdView!.closeButton.addTarget(self, action: "closeInterstitialAd", forControlEvents: .TouchUpInside)
    skView.addSubview(interstitialAdView!)
    
    // Pause view
    skView.paused = true
    
    // Present ad in view
    interstitialAdView!.presentInterstitialAd(interstitialAd!)
    
    return true
  }
  
  func closeInterstitialAd() {
    // Clean up
    interstitialAdView?.removeFromSuperview()
    resetInterstitialAd()

    // Unpause view
    skView.paused = false
    
    // Restart game
    if let gameScene = skView.scene as? GameScene {
      gameScene.startGame()
    }
  }
  
  func resetInterstitialAd() {
    interstitialAd?.delegate = nil
    interstitialAd = nil
    interstitialAdView = nil
  }
  
  // MARK: - IAP
  func presentStoreActionSheet() {
    if let removeAdsProduct = removeAdsProduct {
      let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

      let purchaseAction = UIAlertAction(title: "Remove ads for \(removeAdsProduct.formattedPrice)", style: .Default) { _ in
        self.purchaseProduct(removeAdsProduct)
      }

      let restoreAction = UIAlertAction(title: "Restore purchase", style: .Default) { _ in
        self.restoreProducts()
      }
      
      actionController.addAction(purchaseAction)
      actionController.addAction(restoreAction)
      actionController.addAction(cancelAction)
    
      presentViewController(actionController, animated: true, completion: nil)
    }
  }
  
  func requestProducts() {
    let productIdentifiers = Set([ProductIdentifier.RemoveAds])
    let request = SKProductsRequest(productIdentifiers: productIdentifiers)
    
    request.delegate = self
    request.start()
  }
  
  func purchaseProduct(product: SKProduct) {
    let payment = SKPayment(product: product)
    let paymentQueue = SKPaymentQueue.defaultQueue()
    
    paymentQueue.addPayment(payment)
  }
  
  func restoreProducts() {
    let paymentQueue = SKPaymentQueue.defaultQueue()
  
    paymentQueue.restoreCompletedTransactions()
  }
  
  func completeTransaction(transaction: SKPaymentTransaction) {
    let queue = SKPaymentQueue.defaultQueue()
    
    provideContentForProductIdentifier(transaction.payment.productIdentifier)
    
    queue.finishTransaction(transaction)
  }
  
  func restoreTransaction(transaction: SKPaymentTransaction) {
    let queue = SKPaymentQueue.defaultQueue()
    
    provideContentForProductIdentifier(transaction.originalTransaction.payment.productIdentifier)
    
    queue.finishTransaction(transaction)
  }
  
  func failedTransaction(transaction: SKPaymentTransaction) {
    let queue = SKPaymentQueue.defaultQueue()
    
    if let error = transaction.error where error.code != SKErrorPaymentCancelled {
      println("Transaction error: \(transaction.error.localizedDescription)")
    }
    
    queue.finishTransaction(transaction)
  }
  
  func provideContentForProductIdentifier(identifier: String) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    userDefaults.setBool(true, forKey: identifier)
    userDefaults.synchronize()
    
    // Feedback
    let alertController = UIAlertController(title: "Thank you", message: "Thank you for your purchase!", preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    
    alertController.addAction(okAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  // MARK: - Sound
  func playMusic() {
    SKTAudio.sharedInstance().playBackgroundMusic(SoundFileName.BackgroundMusic)
  }
  
  func stopMusic() {
    SKTAudio.sharedInstance().pauseBackgroundMusic()
  }

  func toggleSoundForScene(scene: SKScene, withButton button: SpriteButtonNode) -> Bool {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    if isSoundEnabled() {
      userDefaults.setValue(true, forKey: KeyForUserDefaults.SoundDisabled)
      button.state = .Active
    } else {
      userDefaults.setValue(false, forKey: KeyForUserDefaults.SoundDisabled)
      button.state = .Normal
    }
    
    userDefaults.synchronize()
    
    return isSoundEnabled()
  }
  
  func toggleMusicForScene(scene: SKScene, withButton button: SpriteButtonNode) -> Bool {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    if isMusicEnabled() {
      userDefaults.setValue(true, forKey: KeyForUserDefaults.MusicDisabled)
      button.state = .Active
      stopMusic()
    } else {
      userDefaults.setValue(false, forKey: KeyForUserDefaults.MusicDisabled)
      button.state = .Normal
      playMusic()
    }
    
    userDefaults.synchronize()
    
    return isMusicEnabled()
  }
  
  // MARK: - GKGameCenterControllerDelegate
  func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
    gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    skView.paused = false
  }
  
  // MARK: - GameCenterManagerDelegate
  func gameCenterManager(manager: GameCenterManager, didProvideViewController viewController: UIViewController) {
    presentViewController(viewController, animated: true, completion: nil)
  }
  
  func gameCenterManager(manager: GameCenterManager, didAuthenticateLocalPlayer: Bool) {
    if didAuthenticateLocalPlayer {
      gameCenterManager.loadDefaultLeaderboardIdentifier()
    }
  }
  
  func gameCenterManager(manager: GameCenterManager, didReceiveError error: NSError) {
    // Cancelled by user
    LoadingIndicatorView.sharedView.dismiss()
  }
  
  func gameCenterManager(manager: GameCenterManager, didLoadDefaultLeaderboardIdentifier identifier: String) {
    gameCenterManager.loadLeaderboardScore()
  }
  
  func gameCenterManager(manager: GameCenterManager, didLoadLocalPlayerScore score: GKScore) {
    gameData.updateTopScoreWithGKScore(score)
    
    LoadingIndicatorView.sharedView.dismiss()
  }
  
  // MARK: - GameSceneDelegate
  func gameSceneDidEnd(gameScene: GameScene) {
    if !gameScene.godMode && gameCenterManager.isAuthenticated {
      let scoreValue = Int64(round(gameScene.gameData.score))

      gameCenterManager.reportScoreValue(scoreValue)
    }
  }
  
  func gameSceneDidStart(gameScene: GameScene) {
    prepareInterstitialAd()
  }
  
  func gameSceneDidRequestRetry(gameScene: GameScene) {
    // Show ad or restart game
    if numberOfRetriesSinceLastAd < MinimumNumberOfRetriesBeforePresentingAd || !presentInterstitialAd() {
      numberOfRetriesSinceLastAd++
      
      gameScene.startGame()
    } else {
      numberOfRetriesSinceLastAd = 0
    }
  }
  
  func gameSceneDidRequestQuit(gameScene: GameScene) {
    presentStartScene()
  }
  
  func gameSceneDidRequestLeaderboard(gameScene: GameScene) {
    presentLeaderboard()
  }
  
  func gameSceneDidRequestToggleSound(gameScene: GameScene, withButton button: SpriteButtonNode) {
    toggleSoundForScene(gameScene, withButton: button)
  }

  func gameSceneDidRequestToggleMusic(gameScene: GameScene, withButton button: SpriteButtonNode) {
    toggleMusicForScene(gameScene, withButton: button)
  }
  
  // MARK: - StartSceneDelegate
  func startSceneDidRequestStart(startScene: StartScene) {
    preloadAndPresentGameScene()
  }

  func startSceneDidRequestLeaderboard(startScene: StartScene) {
    presentLeaderboard()
  }
  
  func startSceneDidRequestStore(stareScene: StartScene) {
    LoadingIndicatorView.sharedView.showInView(view)

    requestProducts()
  }
  
  func startSceneDidRequestToggleSound(startScene: StartScene, withButton button: SpriteButtonNode) {
    toggleSoundForScene(startScene, withButton: button)
  }

  func startSceneDidRequestToggleMusic(startScene: StartScene, withButton button: SpriteButtonNode) {
    toggleMusicForScene(startScene, withButton: button)
  }
  
  // MARK: - ADInterstitialAdDelegate
  func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
    resetInterstitialAd()
  }
  
  func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
    resetInterstitialAd()
    
    println(error)
  }

  func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
    println("Ad loaded")
  }
  
  func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
    closeInterstitialAd()
  }
  
  // MARK: - SKProductsRequestDelegate
  func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
    products = response.products as? [SKProduct]
    
    if let products = products {
      for product in products {
        if product.productIdentifier == ProductIdentifier.RemoveAds {
          removeAdsProduct = product
        }
        
        break
      }
    }

    // Hide indicator
    LoadingIndicatorView.sharedView.dismiss()

    // Present products
    presentStoreActionSheet()
  }
  
  // MARK: - SKPaymentTransactionObserver
  func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
    if let transactions = transactions {
      for transaction in transactions {
        if let transaction = transaction as? SKPaymentTransaction {
          switch (transaction.transactionState) {
          case SKPaymentTransactionState.Purchased:
            completeTransaction(transaction)

          case SKPaymentTransactionState.Restored:
            restoreTransaction(transaction)

          default:
            failedTransaction(transaction)
          }
        }
      }
    }
  }
}
