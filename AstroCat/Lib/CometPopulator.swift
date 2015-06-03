//
//  CometPopulator.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class CometPopulator {
  weak var world: WorldNode?
  
  var emitters = [CometEmitter]()

  init() {
  }
  
  // MARK: - Emitter
  func addEmittersIfNeeded() {
    if let world = world, scene = world.scene {
      let speed: CGFloat = 400
      let sceneFrame = world.convertFrame(scene.frame, fromNode: scene)
      let fromPosition = CGPoint(x: sceneFrame.maxX, y: sceneFrame.maxY)
      let toPosition = CGPoint(x: sceneFrame.minX, y: sceneFrame.minY)
      let emitter = CometEmitter(speed: speed, fromPosition: fromPosition, toPosition: toPosition)
      
      emitter.populator = self
      emitter.startEmit()
      
      emitters << emitter
    }
  }
  
  func removeEmittersIfNeeded() {
  
  }
}
