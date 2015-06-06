//
//  GameScene.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, WorldDelegate, ButtonDelegate, GameDataSource {
  // MARK: - Immutable var
  let world = WorldNode()
  let hud = HUDNode()
  let pauseButton = IconButtonNode(circleOfRadius: 30)
  let background = SceneBackgroundNode()
  let bottomBoundary = LineBoundaryNode(length: SceneSize.width, axis: .X)
  let cometPopulator = CometPopulator()
  
  // MARK: - Vars
  weak var gameSceneDelegate: GameSceneDelegate?
  var gameData = GameData.dataFromArchive()
  var gameStarted = false
  var godMode = false

  lazy var pauseMenu: PauseMenuNode = {
    let pauseMenu = PauseMenuNode(size: SceneSize)
    
    pauseMenu.resumeButton.delegate = self
    pauseMenu.quitButton.delegate = self
    
    return pauseMenu
  }()

  // MARK: - View
  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor(hexString: "#323257")
    
    // Physics
    physicsWorld.contactDelegate = self
    physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    
    // World
    world.delegate = self
    addChild(world)
    
    // Populator
    cometPopulator.world = world
    cometPopulator.dataSource = self
    
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
    if world.player.isAlive && gameStarted {
      world.player.updateDistanceTravelled()

      gameData.updateScoreForPlayer(world.player)
      hud.updateWithGameData(gameData)
    }
    
    if world.player.isAlive {
      if world.player.shouldMove {
        world.player.moveUpward()
      } else {
        world.player.brake()
      }
    }
  }
  
  // MARK: - Update
  override func didSimulatePhysics() {
    // Camera
    world.followPlayer()
    
    // Background
    background.move(world.position)
    
    // Comet
    if world.player.isAlive {
      cometPopulator.update()
    }
  }
  
  // MARK: - Event
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    // world.player.jump()
    world.player.shouldMove = true
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    world.player.shouldMove = false
  }
  
  // MARK: - Gameflow
  func startGame() {
    // Comets
    cometPopulator.removeAllEmitters()

    // Player
    world.camera.position = CGPointZero
    world.player.position = CGPoint(x: frame.midX, y: world.ground.frame.maxY)
    world.player.respawn()
    world.followPlayer()
    
    afterDelay(1) {
      self.world.player.initialPosition = self.world.player.position
    }
    
    // Data
    gameData.reset()
    gameStarted = true
  }
  
  func endGame() {
    gameData.updateTopScore()
    gameData.saveToArchive()
    
    // Delegate
    gameSceneDelegate?.gameScene?(self, didEndGameWithScore: gameData.score)
    
    // Kill player
    world.player.kill()
    gameStarted = false

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
      if gameStarted && world.player.isAlive {
        endGame()
      }
      
    case PhysicsCategory.Player | PhysicsCategory.Award:
      if let comet = nodeInContact(contact, withCategoryBitMask: PhysicsCategory.Award) as? CometNode {
        if gameStarted && world.player.isAlive && comet.enabled && !world.player.isProtected {
          world.player.isProtected = true

          comet.enabled = false
          comet.emitter?.removeComet(comet)
        }
      }
    
    case PhysicsCategory.Player | PhysicsCategory.Comet:
      if godMode {
        return
      }
      
      if let comet = nodeInContact(contact, withCategoryBitMask: PhysicsCategory.Comet) as? CometNode {
        if gameStarted && world.player.isAlive && comet.enabled {
          if world.player.isProtected {
            world.player.isProtected = false
          } else {
            endGame()
          }

          comet.enabled = false
          comet.emitter?.removeComet(comet)
        }
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
    gameData.saveToArchive()
    pauseGame(true)
  }
  
  dynamic private func applicationDidEnterBackground(notification: NSNotification) {
  }
  
  dynamic private func applicationDidBecomeActive(notification: NSNotification) {
  }
  
  dynamic private func applicationWillEnterForeground(notification: NSNotification) {
  }
}
