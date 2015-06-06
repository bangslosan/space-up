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
  var interstitialAdView: InterstitialAdView?
  var interstitialAd: ADInterstitialAd?

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
    
    // Configure controller
    // interstitialPresentationPolicy = .Manual
    
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
    notificationCenter.addObserver(self, selector: "didEndGameNotification:", name: DidEndGameNotifiation, object: nil)
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
  
  func didEndGameNotification(notification: NSNotification) {
    presentInterstitialAd()
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
  func presentInterstitialAd() {
    if presentingFullScreenAd || interstitialAd != nil {
      return
    }

    interstitialAd = ADInterstitialAd()
    interstitialAd!.delegate = self
  }
  
  func closeInterstitialAd() {
    interstitialAdView?.removeFromSuperview()
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
  func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
    // Container view
    interstitialAdView = InterstitialAdView(frame: skView.bounds)
    interstitialAdView!.closeButton.addTarget(self, action: "closeInterstitialAd", forControlEvents: .TouchUpInside)
    skView.addSubview(interstitialAdView!)
    
    // Present ad in view
    interstitialAdView!.presentInterstitialAd(interstitialAd)
  }

  func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
    closeInterstitialAd()
  }
  
  func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
    closeInterstitialAd()
  }
  
  func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
    closeInterstitialAd()
  }
}
