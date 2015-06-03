//
//  GameScene.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, WorldDelegate, ButtonDelegate {
  // MARK: - Immutable var
  let world = WorldNode()
  let hud = HUDNode()
  let pauseButton = IconButtonNode(circleOfRadius: 30)
  let background = SceneBackgroundNode()
  let bottomBoundary = LineBoundaryNode(length: SceneSize.width, axis: .X)
  
  // MARK: - Vars
  var gameData = GameData.sharedGameData

  lazy var pauseMenu: PauseMenuNode = {
    let pauseMenu = PauseMenuNode(size: SceneSize)
    
    pauseMenu.resumeButton.delegate = self
    pauseMenu.quitButton.delegate = self
    
    return pauseMenu
  }()

  // MARK: - View
  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor(hexString: "#000000")
    
    // Physics
    physicsWorld.contactDelegate = self
    physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    
    // World
    world.delegate = self
    addChild(world)
    
    // Backgrounds
    addChild(background)
    background.world = world
    background.move(world.position)
    
    // Bottom bound
    bottomBoundary.position = CGPointZero
    addChild(bottomBoundary)
    
    // HUD
    hud.zPosition = 100
    hud.position = CGPoint(x: screenFrame.minX, y: screenFrame.maxY)
    addChild(hud)
    
    // Pause button
    pauseButton.delegate = self
    pauseButton.zPosition = 100
    pauseButton.position = CGPoint(x: screenFrame.maxX, y: screenFrame.maxY) -
      CGPoint(x: pauseButton.frame.width / 2 + 20, y: pauseButton.frame.height / 2 + 20)
    addChild(pauseButton)
    
    // Notification
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
    notificationCenter.addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    notificationCenter.addObserver(self, selector: "applicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    notificationCenter.addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    
    // Start Game
    startGame()
  }
  
  override func willMoveFromView(view: SKView) {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // MARK: - Scene
  override func update(currentTime: CFTimeInterval) {
    // Score
    if world.player.isAlive && gameData.shouldUpdate {
      gameData.update()
    }
    
    if world.player.isAlive && gameData.energy == 0 {
      // endGame()
    }
    
    // HUD
    hud.update()
  }
  
  // MARK: - Update
  override func didSimulatePhysics() {
    // Camera
    world.followPlayer()
    
    // Background
    background.move(world.position)
  }
  
  // MARK: - Event
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    world.player.jump()
  }
  
  // MARK: - Gameflow
  func startGame() {
    // Player
    world.player.position = CGPoint(x: frame.midX, y: frame.midY)
    world.camera.position = CGPointZero
    
    world.player.isAlive = true
    gameData.shouldUpdate = true
    world.followPlayer()
    world.cometPopulator.addEmittersIfNeeded()
  }
  
  func endGame() {
    world.player.isAlive = false
    gameData.shouldUpdate = false

    // Alert
    if let controller = UIApplication.sharedApplication().delegate?.window??.rootViewController {
      let alertController = UIAlertController(title: "Game Over", message: "Sorry, please start again", preferredStyle: .Alert)
      let alertAction = UIAlertAction(title: "OK", style: .Default) { _ in
        self.startGame()
      }
      
      alertController.addAction(alertAction)
      
      controller.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  func togglePauseGame() {
    pauseGame(paused == true ? false : true)
  }
  
  func pauseGame(paused: Bool) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    view?.paused = paused
    
    if paused {
      addChildIfNeeded(pauseMenu)
      
      notificationCenter.postNotificationName(DidPauseGameNotification, object: self)
    } else {
      pauseMenu.removeFromParent()
      
      notificationCenter.postNotificationName(DidResumeGameNotification, object: self)
    }
  }
  
  // MARK: - ButtonDelegate
  func touchBeganForButton(button: ButtonNode) {
    switch button {
    case pauseButton:
      togglePauseGame()
      
    case pauseMenu.resumeButton:
      pauseGame(false)
      
    case pauseMenu.quitButton:
      let notificationCenter = NSNotificationCenter.defaultCenter()
      
      notificationCenter.postNotificationName(DidRequestQuitGameNotification, object: self)
      
    default:
      break
    }
  }
  
  // MARK: - SKPhysicsContactDelegate
  func didBeginContact(contact: SKPhysicsContact) {
    let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch collision {
    case PhysicsCategory.Player | PhysicsCategory.Boundary:
      if gameData.shouldUpdate && world.player.isAlive {
        endGame()
      }

    default:
      break
    }
  }
  
  func didEndContact(contact: SKPhysicsContact) {
    let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
  }
  
  // MARK: - NSNotification
  dynamic private func applicationWillResignActive(notification: NSNotification) {
    pauseGame(true)
  }
  
  dynamic private func applicationDidEnterBackground(notification: NSNotification) {
  }
  
  dynamic private func applicationDidBecomeActive(notification: NSNotification) {
  }
  
  dynamic private func applicationWillEnterForeground(notification: NSNotification) {
  }
}
