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
  func update() {
    addEmittersIfNeeded()
    removeEmittersIfNeeded()
  }

  func addEmittersIfNeeded() {
    if let world = world, scene = world.scene {
      var lastToPosition: CGPoint?
      
      if let lastEmitter = emitters.last {
        lastToPosition = scene.convertPoint(lastEmitter.toPosition, fromNode: world)
      }
      
      if lastToPosition?.y < scene.frame.maxY * 2 || emitters.last == nil {
        let (fromPosition, toPosition) = positionForNewEmitter()
        
        if let emitter = addEmitter(fromPosition, toPosition: toPosition) {
          if toPosition.y > scene.frame.maxY {
            emitter.startEmitAt(CGFloat.random(min: 0.5, max: 1))
          } else {
            emitter.startEmitAt(1)
          }
        }
      }
    }
  }
  
  func positionForNewEmitter() -> (fromPosition: CGPoint, toPosition:CGPoint) {
    if let world = world, scene = world.scene {
      let spacing: CGFloat = 420
      let initialOffset = CGPoint(x: 0, y: 200)

      var lastToPosition: CGPoint?
      var lastFromPosition: CGPoint?
      var fromPosition: CGPoint
      var toPosition: CGPoint
    
      if let lastEmitter = emitters.last {
        lastToPosition = scene.convertPoint(lastEmitter.toPosition, fromNode: world)
        lastFromPosition = scene.convertPoint(lastEmitter.fromPosition, fromNode: world)
      }
    
      if lastFromPosition != nil {
        fromPosition = lastFromPosition! + CGPoint(x: 0, y: spacing)
      } else {
        fromPosition = CGPoint(x: scene.frame.maxX, y: scene.frame.maxX + initialOffset.y)
      }
      
      if lastToPosition != nil {
        toPosition = lastToPosition! + CGPoint(x: 0, y: spacing)
      } else {
        toPosition = CGPoint(x: scene.frame.minX, y: scene.frame.minY + initialOffset.y)
      }
      
      fromPosition = world.convertPoint(fromPosition, fromNode: scene)
      toPosition = world.convertPoint(toPosition, fromNode: scene)
      
      return (fromPosition, toPosition)
    }
    
    return (CGPointZero, CGPointZero)
  }
  
  func removeEmittersIfNeeded() {
    if let world = world, scene = world.scene, emitter = emitters.first {
      if scene.convertPoint(emitter.toPosition, fromNode: world).y < scene.frame.minY - scene.frame.height * 2 {
        removeEmitter(emitter)
      }
    }
  }
  
  func removeAllEmitters() {
    for emitter in emitters {
      emitter.removeAllComets()
      removeEmitter(emitter)
    }
  }
  
  func addEmitter(fromPosition: CGPoint, toPosition: CGPoint) -> CometEmitter? {
    if let world = world, scene = world.scene {
      let speed: CGFloat = CGFloat.random(min: 200, max: 300)
      let type = CometType.randomType()
      let emitter = CometEmitter(type: type, speed: speed, fromPosition: fromPosition, toPosition: toPosition)
      
      emitters << emitter
      
      emitter.populator = self
      
      return emitter
    }
    
    return nil
  }
  
  func removeEmitter(emitter: CometEmitter) {
    emitter.endEmit()
    removeObjectByReference(emitter, fromArray: &emitters)
  }
}
