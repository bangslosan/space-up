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

class GameViewController: UIViewController, GKGameCenterControllerDelegate, ADBannerViewDelegate, GameCenterManagerDelegate, GameSceneDelegate {
  // MARK - Immutable vars
  let gameCenterManager = GameCenterManager()

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
    
    // Configure the view.
    skView.showsFPS = true
    skView.showsNodeCount = true
    // skView.showsPhysics = true
    skView.ignoresSiblingOrder = true
    
    // Present scene
    presentStartScene()
    
    // Present ad
    let adView = ADBannerView(adType: .Banner)
    adView.delegate = self
    skView.addSubview(adView)
    
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
  
  // MARK: - Leaderboard
  func presentLeaderboardViewControllerWithIdentifier(identifier: String) -> GKGameCenterViewController {
    let leaderboardViewController = GKGameCenterViewController()
    
    leaderboardViewController.gameCenterDelegate = self
    leaderboardViewController.viewState = .Leaderboards
    leaderboardViewController.leaderboardIdentifier = identifier
    
    presentViewController(leaderboardViewController, animated: true, completion: nil)
    
    return leaderboardViewController
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
  
  // MARK: - ADBannerViewDelegate
  func bannerViewDidLoadAd(banner: ADBannerView!) {
    banner.frame.origin.y = skView.frame.height - banner.frame.height
  }
  
  func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
    
  }
  
  func bannerViewActionDidFinish(banner: ADBannerView!) {
    
  }
}
