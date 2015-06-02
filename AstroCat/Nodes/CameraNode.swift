//
//  CameraNode.swift
//  AstroCat
//
//  Created by David Chin on 18/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class CameraNode: SKNode {
  // MARK: - Follow
  func followPlayer(player: PlayerNode) {
    if let scene = scene, playerParent = player.parent {
      var cameraPosition = position
      var boundaryFrame = playerParent.convertFrame(scene.frame, fromNode: scene)
      
      cameraPosition.x = player.position.x.clamped(boundaryFrame.minX, boundaryFrame.maxX)
      cameraPosition.y = max(cameraPosition.y, player.position.y, scene.frame.midY)

      position = cameraPosition
    }
  }
  
  func centerWorld(world: WorldNode) {
    if let worldParent = world.parent, scene = scene {
      let offset = CGPoint(x: -scene.size.width / 2, y: -scene.size.height / 2)
      let cameraPosition = worldParent.convertPoint(position, fromNode: world) + offset

      world.position -= cameraPosition
    }
  }
}
