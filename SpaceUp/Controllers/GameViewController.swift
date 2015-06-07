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

class GameViewController: UIViewController, GKGameCenterControllerDelegate, ADInterstitialAdDelegate, GameCenterManagerDelegate, GameSceneDelegate, StartSceneDelegate {
  // MARK: - Immutable vars
  let gameCenterManager = GameCenterManager()
  
  // MARK: - Vars
  private var interstitialAdView: InterstitialAdView?
  private var interstitialAd: ADInterstitialAd?
  private var numberOfRetriesSinceLastAd: UInt = 0

  // MARK: - Computed vars
  var skView: SKView! {
    return view as? SKView
  }
  
  // MARK: - View
  override func loadView() {
    view = SKView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // iAd
    interstitialPresentationPolicy = .Manual
    
    // Configure the view.
    skView.showsFPS = true
    skView.showsNodeCount = true
    // skView.showsPhysics = true
    skView.ignoresSiblingOrder = true
    
    // Present scene
    presentStartScene()
    
    // Authenticate GameCenter
    // TODO: Loading spinner
    gameCenterManager.delegate = self
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
    
    // Background music
    SKTAudio.sharedInstance().pauseBackgroundMusic()
    
    return scene
  }
  
  func presentGameScene() -> GameScene {
    let scene = GameScene(size: SceneSize)
    scene.scaleMode = .AspectFill
    scene.gameSceneDelegate = self
    
    // Present scene
    skView.presentScene(scene)
    
    // Background music
    if isMusicEnabled() {
      SKTAudio.sharedInstance().playBackgroundMusic("BackgroundMusic.mp3")
    } else {
      SKTAudio.sharedInstance().pauseBackgroundMusic()
    }
    
    return scene
  }
  
  // MARK: - Leaderboard
  func presentLeaderboardViewControllerWithIdentifier(identifier: String) -> GKGameCenterViewController {
    let leaderboardViewController = GKGameCenterViewController()
    
    leaderboardViewController.gameCenterDelegate = self
    leaderboardViewController.viewState = .Leaderboards
    leaderboardViewController.leaderboardIdentifier = identifier
    
    presentViewController(leaderboardViewController, animated: true, completion: nil)
    
    return leaderboardViewController
  }
  
  // MARK: - Ad
  func prepareInterstitialAd() {
    interstitialAd = ADInterstitialAd()
    interstitialAd!.delegate = self
  }

  func presentInterstitialAd() -> Bool {
    if interstitialAd?.loaded == true {
      // Container view
      interstitialAdView = InterstitialAdView(frame: skView.bounds)
      interstitialAdView!.closeButton.addTarget(self, action: "closeInterstitialAd", forControlEvents: .TouchUpInside)
      skView.addSubview(interstitialAdView!)
      
      // Present ad in view
      interstitialAdView!.presentInterstitialAd(interstitialAd!)
      
      // Pause view
      skView.paused = true
      
      return true
    } else {
      println("Ad not loaded")

      return false
    }
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
  
  // MARK: - GKGameCenterControllerDelegate
  func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
    gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - GameCenterManagerDelegate
  func gameCenterManager(manager: GameCenterManager, didProvideViewController viewController: UIViewController) {
    presentViewController(viewController, animated: true, completion: nil)
  }
  
  func gameCenterManager(manager: GameCenterManager, didAuthenticateLocalPlayer: Bool) {
    if didAuthenticateLocalPlayer {
      // TODO: Loading spinner
      gameCenterManager.loadDefaultLeaderboardIdentifier()
    }
  }
  
  // MARK: - GameSceneDelegate
  func gameSceneDidEnd(gameScene: GameScene) {
    let scoreValue = Int64(round(gameScene.gameData.score))

    gameCenterManager.reportScoreValue(scoreValue)
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
  
  // MARK: - StartSceneDelegate
  func startSceneDidRequestStart(startScene: StartScene) {
    presentGameScene()
  }

  func startSceneDidRequestLeaderboard(startScene: StartScene) {
    if let leaderboardIdentifier = gameCenterManager.leaderboardIdentifier {
      presentLeaderboardViewControllerWithIdentifier(leaderboardIdentifier)
    }
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
}
