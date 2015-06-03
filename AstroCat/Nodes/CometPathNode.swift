//
//  CometPathNode.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class CometPathNode: SKShapeNode {
  init(fromPosition: CGPoint, toPosition: CGPoint) {
    super.init()
    
    var path = CGPathCreateMutable()
    
    CGPathMoveToPoint(path, nil, fromPosition.x, fromPosition.y)
    CGPathAddLineToPoint(path, nil, toPosition.x, toPosition.y)
    
    self.path = path
    strokeColor = UIColor.redColor()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
