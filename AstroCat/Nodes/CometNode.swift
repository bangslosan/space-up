//
//  CometNode.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let moveFromPositionAction = "moveFromPositionAction"
}

class CometNode: SKSpriteNode {
  init() {
    let color = UIColor(hexString: "#ffffff")
    let size = CGSize(width: 30, height: 30)

    super.init(texture: nil, color: color, size: size)
    
    // Physics
    physicsBody = SKPhysicsBody(rectangleOfSize: size)
    physicsBody!.categoryBitMask = PhysicsCategory.Comet
    physicsBody!.collisionBitMask = PhysicsCategory.Comet
    physicsBody!.affectedByGravity = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Movement
  func moveFromPosition(position: CGPoint, toPosition: CGPoint, rate: CGFloat = 1/200, completion: (() -> Void)?) {
    self.position = position
    
    let action = SKAction.sequence([
      SKAction.waitForDuration(1),
      SKAction.moveTo(toPosition, duration: Double(toPosition.distanceTo(position) * rate), timingMode: .EaseOut),
      SKAction.runBlock { completion?() }
    ])
    
    runAction(action, withKey: KeyForAction.moveFromPositionAction)
  }
}
