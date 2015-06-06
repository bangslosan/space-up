//
//  GameViewController.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit
import GameKit
import iAd

class GameViewController: UIViewController, GKGameCenterControllerDelegate, ADInterstitialAdDelegate, GameCenterManagerDelegate, GameSceneDelegate {
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
  
  override func viewWillAppear(animated: Bool) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    notificationCenter.addObserver(self, selector: "didRequestStartGameNotification:", name: DidRequestStartGameNotification, object: nil)
    notificationCenter.addObserver(self, selector: "didRequestQuitGameNotification:", name: DidRequestQuitGameNotification, object: nil)
    notificationCenter.addObserver(self, selector: "didRequestLeaderboardNotification:", name: DidRequestLeaderboardNotification, object: nil)
    notificationCenter.addObserver(self, selector: "didRequestRetryGameNotification:", name: DidRequestRetryGameNotification, object: nil)
    notificationCenter.addObserver(self, selector: "didEndGameNotification:", name: DidEndGameNotification, object: nil)
    notificationCenter.addObserver(self, selector: "didStartGameNotification:", name: DidStartGameNotification, object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    notificationCenter.removeObserver(self)
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
    
    skView.presentScene(scene)
    
    return scene
  }
  
  func presentGameScene() -> GameScene {
    let scene = GameScene(size: SceneSize)
    scene.scaleMode = .AspectFill
    scene.gameSceneDelegate = self
    
    skView.presentScene(scene)
    
    return scene
  }
  
  // MARK: - Notification
  func didRequestStartGameNotification(notification: NSNotification) {
    presentGameScene()
  }
  
  func didRequestQuitGameNotification(notification: NSNotification) {
    presentStartScene()
  }
  
  func didRequestLeaderboardNotification(notification: NSNotification) {
    if gameCenterManager.leaderboardIdentifier == nil {
      return
    }
    
    presentLeaderboardViewControllerWithIdentifier(gameCenterManager.leaderboardIdentifier!)
  }
  
  func didRequestRetryGameNotification(notification: NSNotification) {
    let gameScene = notification.object as? GameScene

    // Show ad or restart game
    if numberOfRetriesSinceLastAd < MinimumNumberOfRetriesBeforePresentingAd || !presentInterstitialAd() {
      numberOfRetriesSinceLastAd++

      gameScene?.startGame()
    } else {
      numberOfRetriesSinceLastAd = 0
    }
  }
  
  func didEndGameNotification(notification: NSNotification) {
  }
  
  func didStartGameNotification(notification: NSNotification) {
    prepareInterstitialAd()
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
  func gameScene(gameScene: GameScene, didEndGameWithScore score: CGFloat) {
    let scoreValue = Int64(round(score))

    gameCenterManager.reportScoreValue(scoreValue)
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
