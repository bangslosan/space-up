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
  let filteredMotion = FilteredMotion()
  
  // MARK: - Vars
  weak var endGameView: EndGameView?
  weak var pauseMenu: PauseMenuView?
  weak var gameSceneDelegate: GameSceneDelegate?
  weak var motionDataSource: MotionDataSource?
  var textures: [SKTexture]?
  var textureAtlases: [SKTextureAtlas]?
  var tip: TapTipNode?
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
    backgroundColor = UIColor(hexString: ColorHex.BackgroundColor)
    
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
    updateMotion()
    addChild(background)
    background.world = world
    // background.updateOffsetByMotion(filteredMotion)
    background.move(world.position)
    
    // Bottom bound
    bottomBoundary.position = CGPoint(x: 0, y: -world.player.frame.height)
    addChild(bottomBoundary)
    
    // HUD
    hud.zPosition = 100
    hud.position = CGPoint(x: screenFrame.midX, y: screenFrame.maxY)
    gameData.updateScoreForPlayer(world.player)
    hud.updateWithGameData(gameData)
    addChild(hud)
    
    // Pause button
    pauseButton.delegate = self
    pauseButton.zPosition = 100
    pauseButton.position = CGPoint(x: screenFrame.maxX, y: screenFrame.maxY) - CGPoint(x: 60, y: 60)
    addChild(pauseButton)
    
    // Tip
    if gameData.shouldShowTip {
      tip = TapTipNode()
      tip!.position = CGPoint(x: screenFrame.midX, y: screenFrame.midY)
      tip!.zPosition = 3
      tip!.alpha = 0
      tip!.appearWithDuration(0.5)
      addChild(tip!)
      
      gameData.shouldShowTip = false
    }
    
    // Notification
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
    notificationCenter.addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    notificationCenter.addObserver(self, selector: "applicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    notificationCenter.addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    
    // Start Game
    pauseGame(false)
    startGame()
  }
  
  override func willMoveFromView(view: SKView) {
    NSNotificationCenter.defaultCenter().removeObserver(self)
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
    world.followPlayer(crawlIncrement)
    
    // Background
    /*
    if round(gameData.score) == 0 {
      background.updateOffsetByMotion(filteredMotion)
    }
    */

    background.move(world.position)
    
    // Comet
    if gameStarted && world.player.isAlive {
      cometPopulator.update()
    }
  }
  
  // MARK: - Event
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if view?.paused == true {
      return
    }

    if world.player.isAlive {
      if !gameStarted {
        gameStarted = true
      }

      world.player.startMoveUpward()
    }

    if let tip = tip {
      tip.removeWithDuration(0.5) {
        self.tip = nil
      }
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if view?.paused == true {
      return
    }

    if world.player.isAlive {
      world.player.endMoveUpward()
    }
  }
  
  // MARK: - Motion
  func updateMotion() {
    if let acceleration = motionDataSource?.accelerometerDataForScene(self)?.acceleration {
      filteredMotion.updateAcceleration(acceleration)
    }
  }
  
  // MARK: - Views
  func presentPauseMenu() -> PauseMenuView {
    let pauseMenu = PauseMenuView()
    
    pauseMenu.zPosition = 1000
    pauseMenu.resumeButton.delegate = self
    pauseMenu.quitButton.delegate = self
    pauseMenu.soundButton.delegate = self
    pauseMenu.musicButton.delegate = self

    addChildIfNeeded(pauseMenu)
    
    return pauseMenu
  }
  
  func presentEndGameView(hasNewTopScore: Bool = false) -> EndGameView {
    let endGameView = EndGameView()
    
    endGameView.zPosition = 1000
    endGameView.continueButton.delegate = self
    endGameView.quitButton.delegate = self
    endGameView.leaderboardButton.delegate = self
    endGameView.updateWithGameData(gameData, hasNewTopScore: hasNewTopScore)

    addChild(endGameView)
    
    return endGameView
  }
  
  // MARK: - Gameflow
  func startGame() {
    if gameStarted || world.player.isAlive {
      return
    }

    // Unpause
    pauseGame(false)
    
    // Comets
    cometPopulator.removeAllEmitters()

    // World
    world.resetPlayerPosition()
    world.player.respawn()
    world.scoreLine.updateWithScore(gameData.topScore, forPlayer: world.player)
    
    // Background
    background.move(world.position)
    
    // Data
    gameData.reset()
    hud.updateWithGameData(gameData)
    
    // Notify
    gameSceneDelegate?.gameSceneDidStart?(self)
  }

  func endGame() {
    let hasNewTopScore = gameData.score > gameData.topScore
  
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
    endGameView = presentEndGameView(hasNewTopScore)
    endGameView!.hidden = true

    afterDelay(0.5) { [weak self] in
      self?.endGameView?.hidden = false
      self?.endGameView?.appear()
    }
  }
  
  func continueGame() {
    pauseGame(false)

    endGameView?.disappear() {
      self.endGameView?.removeFromParent()
      self.endGameView = nil
      
      // Inform delegate
      self.gameSceneDelegate?.gameSceneDidRequestRetry?(self)
    }
  }
  
  func togglePauseGame() {
    if paused {
      pauseGame(false)
    } else {
      pauseGame(true)
    }
  }
  
  func pauseGame(paused: Bool, presentMenuIfNeeded: Bool = true) {
    if paused {
      if presentMenuIfNeeded {
        pauseMenu = presentPauseMenu()
      }
      
      let pauseAction = SKAction.runBlock {
        self.view?.paused = true
        self.gameSceneDelegate?.gameSceneDidPause?(self)
      }
      
      runAction(pauseAction)
    } else {
      pauseMenu?.removeFromParent()
      pauseMenu = nil
      view?.paused = false
      
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
    // let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
  }
  
  // MARK: - NSNotification
  dynamic private func applicationWillResignActive(notification: NSNotification) {
    if world.player.isAlive {
      pauseGame(false)
    }
  }
  
  dynamic private func applicationDidEnterBackground(notification: NSNotification) {
  }
  
  dynamic private func applicationDidBecomeActive(notification: NSNotification) {
    if world.player.isAlive {
      pauseGame(true)
    }
  }
  
  dynamic private func applicationWillEnterForeground(notification: NSNotification) {
  }
}
