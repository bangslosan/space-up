//
//  CometPopulator.swift
//  SpaceUp
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class CometPopulator {
  weak var world: WorldNode?
  weak var dataSource: GameDataSource?
  
  var emitters = [CometEmitter]()

  init() {
  }
  
  // MARK: - Emitter
  func update() {
    addEmittersIfNeeded()
    removeEmittersIfNeeded()
  }

  func addEmittersIfNeeded() {
    if let world = world, scene = world.scene, gameData = dataSource?.gameData {
      var lastToPosition: CGPoint?
      
      if let lastEmitter = emitters.last {
        lastToPosition = scene.convertPoint(lastEmitter.toPosition, fromNode: world)
      }
      
      if lastToPosition?.y < scene.frame.maxY * 2 || emitters.last == nil {
        let type = randomCometType()
        let (fromPosition, toPosition) = positionForNewEmitterOfType(type)
        
        if let emitter = addEmitterOfType(type, fromPosition: fromPosition, toPosition: toPosition) {
          if toPosition.y > scene.frame.maxY {
            emitter.startEmit(speedFactor: gameData.levelFactor, initialPercentage: CGFloat.random(min: 0, max: 0.5))
          } else {
            emitter.startEmit(speedFactor: gameData.levelFactor, initialPercentage: 0)
          }
        }
      }
    }
  }
  
  func positionForNewEmitterOfType(type: CometType) -> (fromPosition: CGPoint, toPosition:CGPoint) {
    if let world = world, scene = world.scene, gameData = dataSource?.gameData {
      let textureSize = SKTexture(imageNamed: TextureFileName.CometLargeGlow).size()
      let spacing: CGFloat = EmitterVerticalSpacing
      let initialFromOffset = CGPoint(x: -textureSize.width, y: scene.frame.height + textureSize.width)
      let initialToOffset = CGPoint(x: textureSize.width, y: scene.frame.height - textureSize.width)

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
        fromPosition = CGPoint(x: scene.frame.minX, y: scene.frame.maxX) + initialFromOffset
      }
      
      if lastToPosition != nil {
        toPosition = lastToPosition! + CGPoint(x: 0, y: spacing)
      } else {
        toPosition = CGPoint(x: scene.frame.maxX, y: scene.frame.minY) + initialToOffset
      }
      
      fromPosition = world.convertPoint(fromPosition, fromNode: scene)
      toPosition = world.convertPoint(toPosition, fromNode: scene)
      
      // Swap direction
      if CGFloat.random(min: 0, max: 1) <= gameData.levelFactor + 0.3 && emitters.count > 0 {
        let oldFromPosition = fromPosition
        
        fromPosition = toPosition
        toPosition = oldFromPosition
      }
      
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
  
  func addEmitterOfType(type: CometType, fromPosition: CGPoint, toPosition: CGPoint) -> CometEmitter? {
    if let gameData = dataSource?.gameData {
      let speedOffset = gameData.levelFactor * 100
      let speed = CGFloat.random(min: 200, max: 300) + speedOffset
      let levelFactor = dataSource?.gameData.levelFactor ?? 0
      let emitter = CometEmitter(type: type, speed: speed, fromPosition: fromPosition, toPosition: toPosition)
      
      emitters << emitter
      
      emitter.populator = self
      
      if !hasEmitterOfType(.Award) && CometType.randomType(levelFactor: levelFactor) == .Award {
        emitter.shouldAward = true
      }
      
      return emitter
    }
    
    return nil
  }
  
  func removeEmitter(emitter: CometEmitter) {
    emitter.endEmit()
    removeObjectByReference(emitter, fromArray: &emitters)
  }
  
  // MARK: - Type
  private func randomCometType() -> CometType {
    let levelFactor = dataSource?.gameData.levelFactor ?? 0
    let type = CometType.randomType(levelFactor: levelFactor, exceptTypes: [.Award])
    
    return type
  }

  private func hasEmitterOfType(type: CometType) -> Bool {
    if type == .Award {
      return emitters.contains { $0.shouldAward == true }
    } else {
      return emitters.contains { $0.type == type }
    }
  }
}
