//
//  ModalOverlayNode.swift
//  SpaceUp
//
//  Created by David Chin on 22/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class ModalOverlayNode: SKShapeNode {
  init(rectOfSize size: CGSize) {
    super.init()
    
    let rect = CGRect(origin: CGPoint(x: size.width / -2, y: size.height / -2), size: size)
    
    path = CGPathCreateWithRect(rect, nil)
    fillColor = UIColor(white: 0, alpha: 0.5)
    strokeColor = UIColor.clearColor()
    position = CGPoint(x: rect.width / 2, y: rect.height / 2)
    userInteractionEnabled = false
    zPosition = -1
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
