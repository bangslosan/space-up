//
//  LineBoundaryNode.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class LineBoundaryNode: SKShapeNode {
  init(length: CGFloat, axis: AxisType) {
    super.init()
    
    // Configure
    let path = CGPathCreateMutable()
    let fromPoint: CGPoint
    let toPoint: CGPoint
    
    switch axis {
    case .X:
      fromPoint = CGPoint(x: 0, y: 0)
      toPoint = CGPoint(x: length, y: 0)
      
    default:
      fromPoint = CGPoint(x: 0, y: 0)
      toPoint = CGPoint(x: 0, y: length)
    }
    
    // Draw Path
    CGPathMoveToPoint(path, nil, fromPoint.x, fromPoint.y)
    CGPathAddLineToPoint(path, nil, toPoint.x, toPoint.y)
    self.path = path
    
    // Fill
    fillColor = UIColor.clearColor()
    strokeColor = UIColor.clearColor()
    
    // Physics
    physicsBody = SKPhysicsBody(edgeFromPoint: fromPoint, toPoint: toPoint)
    physicsBody!.categoryBitMask = PhysicsCategory.Boundary
    physicsBody!.contactTestBitMask = PhysicsCategory.Player
    physicsBody!.collisionBitMask = PhysicsCategory.Player
    physicsBody!.usesPreciseCollisionDetection = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
