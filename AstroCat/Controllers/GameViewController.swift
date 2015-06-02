//
//  GameViewController.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
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
  }
  
  override func viewWillAppear(animated: Bool) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    notificationCenter.addObserver(self, selector: "didRequestStartGameNotification:", name: DidRequestStartGameNotification, object: nil)
    notificationCenter.addObserver(self, selector: "didRequestQuitGameNotification:", name: DidRequestQuitGameNotification, object: nil)
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
}
