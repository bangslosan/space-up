//
//  GameScene.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate, WorldDelegate, ButtonDelegate, GameDataSource {
  // MARK: - Immutable var
  unowned let gameData: GameData
  let world = WorldNode()
  let hud = HUDNode()
  let pauseButton = IconButtonNode(size: CGSize(width: 70, height: 70), text: "\u{f04c}")
  let background = SceneBackgroundNode()
  let bottomBoundary = LineBoundaryNode(length: SceneSize.width, axis: .X)
  let cometPopulator = CometPopulator()
  let motionManager = CMMotionManager()
  let filteredMotion = FilteredMotion(type: .None, factor: 0)
  
  // MARK: - Vars
  weak var endGameView: EndGameView?
  weak var pauseMenu: PauseMenuView?
  weak var gameSceneDelegate: GameSceneDelegate?
  var textures: [SKTexture]?
  var textureAtlases: [SKTextureAtlas]?
  var gameStarted = false
  var godMode = false
  
  // MARK: - Init
  init(size: CGSize, gameData: GameData) {
    self.gameData = gameData

    super.init(size: size)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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
    bottomBoundary.position = CGPoint(x: 0, y: -world.player.frame.height)
    addChild(bottomBoundary)
    
    // HUD
    hud.zPosition = 100
    hud.position = CGPoint(x: screenFrame.midX, y: screenFrame.maxY)
    addChild(hud)
    
    // Pause button
    pauseButton.delegate = self
    pauseButton.zPosition = 100
    pauseButton.position = CGPoint(x: screenFrame.maxX, y: screenFrame.maxY) - CGPoint(x: 60, y: 60)
    addChild(pauseButton)
    
    // Notification
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
    notificationCenter.addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    notificationCenter.addObserver(self, selector: "applicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    notificationCenter.addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    
    // Motion
    observeMotion()
    
    // Start Game
    pauseGame(false)
    startGame()
  }
  
  override func willMoveFromView(view: SKView) {
    NSNotificationCenter.defaultCenter().removeObserver(self)
    
    // Motion
    stopObservingMotion()
  }
  
  // MARK: - Scene
  override func update(currentTime: CFTimeInterval) {
    // Motion
    updateMotion()

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
      
      /*
      if world.player.state != .Standing {
        world.player.moveByMotion(filteredMotion)
      }
      */
    }
  }
  
  // MARK: - Update
  override func didSimulatePhysics() {
    var crawlIncrement: CGFloat = 0
    
    if world.player.state != .Standing {
      crawlIncrement = 1 + MaximumCameraCrawlIncrement * gameData.levelFactor
    }

    // Camera
    world.followPlayer(crawlIncrement: crawlIncrement)
    
    // Background
    background.move(world.position)
    
    // Comet
    if world.player.isAlive {
      cometPopulator.update()
    }
  }
  
  // MARK: - Motion
  func observeMotion() {
    // Motion manager
    if motionManager.accelerometerAvailable && !motionManager.accelerometerActive {
      motionManager.accelerometerUpdateInterval = 1/100
      motionManager.startAccelerometerUpdates()
    }
  }
  
  func stopObservingMotion() {
    motionManager.stopAccelerometerUpdates()
  }
  
  func updateMotion() {
    if let acceleration = motionManager.accelerometerData?.acceleration {
      filteredMotion.updateAcceleration(acceleration)
    }
  }
  
  // MARK: - Event
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    if view?.paused == true {
      return
    }

    if world.player.isAlive {
      world.player.startMoveUpward()
    }
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    if view?.paused == true {
      return
    }

    if world.player.isAlive {
      world.player.endMoveUpward()
    }
  }
  
  // MARK: - Views
  func presentPauseMenu() -> PauseMenuView {
    let pauseMenu = PauseMenuView(size: SceneSize)
    
    pauseMenu.zPosition = 1000
    pauseMenu.resumeButton.delegate = self
    pauseMenu.quitButton.delegate = self
    pauseMenu.soundButton.delegate = self
    pauseMenu.musicButton.delegate = self

    addChildIfNeeded(pauseMenu)
    
    return pauseMenu
  }
  
  func presentEndGameView() -> EndGameView {
    let endGameView = EndGameView(size: SceneSize)
    
    endGameView.zPosition = 1000
    endGameView.continueButton.delegate = self
    endGameView.quitButton.delegate = self
    endGameView.leaderboardButton.delegate = self
    endGameView.updateWithGameData(gameData)

    addChild(endGameView)
    
    return endGameView
  }
  
  // MARK: - Gameflow
  func startGame() {
    // Comets
    cometPopulator.removeAllEmitters()

    // World
    world.resetPlayerPosition()
    world.player.respawn()
    world.scoreLine.updateWithScore(gameData.topScore, forPlayer: world.player)
    
    // Data
    gameData.reset()
    gameStarted = true
    
    // Notify
    gameSceneDelegate?.gameSceneDidStart?(self)
  }

  func endGame() {
    if !godMode {
      gameData.updateTopScore()
      gameData.saveToArchive()
    }
    
    // Delegate
    gameSceneDelegate?.gameSceneDidEnd?(self)
    
    // Kill player
    world.player.kill()
    gameStarted = false

    // End view
    endGameView = presentEndGameView()
    endGameView!.appear()
  }
  
  func continueGame() {
    endGameView?.removeFromParent()
    gameSceneDelegate?.gameSceneDidRequestRetry?(self)
  }
  
  func togglePauseGame() {
    if paused {
      pauseGame(false)
    } else {
      pauseGame(true)
    }
  }
  
  func pauseGame(paused: Bool, presentMenuIfNeeded: Bool = true) {
    view?.paused = paused
    
    if paused {
      if presentMenuIfNeeded {
        pauseMenu = presentPauseMenu()
      }
      
      gameSceneDelegate?.gameSceneDidPause?(self)
    } else {
      pauseMenu?.removeFromParent()
      pauseMenu = nil
      
      gameSceneDelegate?.gameSceneDidResume?(self)
    }
  }
  
  // MARK: - ButtonDelegate
  func touchBeganForButton(button: ButtonNode) {
    if button == pauseButton {
      togglePauseGame()
    } else if button == pauseMenu?.resumeButton {
      pauseGame(false)
    } else if button == pauseMenu?.quitButton || button == endGameView?.quitButton {
      gameSceneDelegate?.gameSceneDidRequestQuit?(self)
    } else if button == pauseMenu?.musicButton {
      gameSceneDelegate?.gameSceneDidRequestToggleMusic?(self, withButton: pauseMenu!.musicButton)
    } else if button == pauseMenu?.soundButton {
      gameSceneDelegate?.gameSceneDidRequestToggleSound?(self, withButton: pauseMenu!.soundButton)
    } else if button == endGameView?.continueButton {
      continueGame()
    } else if button == endGameView?.leaderboardButton {
      gameSceneDelegate?.gameSceneDidRequestLeaderboard?(self)
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
      if let comet = nodeInContact(contact, withCategoryBitMask: PhysicsCategory.Comet) as? CometNode {
        if gameStarted && world.player.isAlive && comet.enabled {
          if world.player.isProtected {
            world.player.isProtected = false
          } else if !godMode {
            endGame()
          }

          comet.explodeAndRemove()
        }
      }
      
    case PhysicsCategory.Player | PhysicsCategory.Ground:
      world.player.stand()

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
