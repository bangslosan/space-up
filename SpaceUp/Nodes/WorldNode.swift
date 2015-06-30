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
  let playerShadowNode = SKShapeNode(ellipseOfSize: CGSize(width: 100, height: 30))
  let ground = GroundNode(size: CGSize(width: SceneSize.width, height: 240))
  let scoreLine = ScoreLineNode(length: SceneSize.width)
  // let tip = SKSpriteNode(imageNamed: TextureFileName.TapTip)
  
  // MARK: - Vars
  weak var delegate: WorldDelegate?
  
  override init() {
    super.init()

    // Camera
    addChild(camera)
    
    // Ground
    addChild(ground)
    
    // Shadow
    playerShadowNode.fillColor = UIColor(hexString: "#9dccbc", alpha: 1)
    playerShadowNode.strokeColor = UIColor.clearColor()
    playerShadowNode.zPosition = 1
    addChild(playerShadowNode)
    
    // Player
    player.zPosition = 2
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
    playerShadowNode.position = player.position

    followPlayer()
  }

  func followPlayer(crawlIncrement: CGFloat = 0) {
    if player.isAlive {
      camera.followPlayer(player, crawlIncrement: crawlIncrement)
      centerCamera()
      
      // Shadow
      let percentage = max(100 - player.distanceTravelled, 0) / 100
      playerShadowNode.alpha = percentage
      playerShadowNode.scaleAsPoint = CGPoint(x: percentage, y: percentage)
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
