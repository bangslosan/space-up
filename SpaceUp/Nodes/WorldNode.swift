//
//  WorldNode.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class WorldNode: SKNode {
  // MARK: - Immutable vars
  let camera = CameraNode()
  let player = PlayerNode()
  let ground = GroundNode(size: CGSize(width: SceneSize.width, height: 240))
  let scoreLine = ScoreLineNode(length: SceneSize.width)
  
  // MARK: - Vars
  weak var delegate: WorldDelegate?
  
  override init() {
    super.init()

    // Camera
    addChild(camera)
    
    // Ground
    addChild(ground)
    
    // Player
    player.zPosition = 1
    addChild(player)
    
    // Score
    scoreLine.alpha = 0.5
    addChild(scoreLine)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Camera
  func resetPlayerPosition() {
    camera.position = CGPointZero
    player.position = CGPoint(x: ground.physicsFrame.midX, y: ground.physicsFrame.maxY)
    player.initialPosition = player.position

    followPlayer()
  }

  func followPlayer(crawlIncrement: CGFloat = 0) {
    if player.isAlive {
      camera.followPlayer(player, crawlIncrement: crawlIncrement)
      centerCamera()
    }
  }
  
  func centerCamera() {
    let previousPosition = position
    
    camera.centerWorld(self)
    
    if previousPosition != position {
      delegate?.world?(self, didMoveFromPosition: previousPosition)
    }
  }
}
