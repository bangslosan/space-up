//
//  ShieldNode.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class ShieldNode: SKShapeNode {
  init(size: CGSize) {
    super.init()
    
    let rect = CGRect(origin: CGPoint(x: size.width * -0.5, y: size.height * -0.5), size: size)
    let path = CGPathCreateWithEllipseInRect(rect, nil)
    
    self.path = path
    fillColor = UIColor(white: 1, alpha: 0.4)
    strokeColor = UIColor.clearColor()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
