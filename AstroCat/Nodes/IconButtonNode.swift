//
//  IconButtonNode.swift
//  AstroCat
//
//  Created by David Chin on 26/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class IconButtonNode: ButtonNode {
  let buttonFace: SKShapeNode

  // MARK: - Init
  init(circleOfRadius radius: CGFloat) {
    buttonFace = SKShapeNode(circleOfRadius: radius)

    super.init()
    
    // Shape
    let minRadius = max(radius, 30)
    let rect = CGRect(x: -minRadius, y: -minRadius, width: minRadius * 2, height: minRadius * 2)
    path = CGPathCreateWithRect(rect, nil)
    
    // Fill color
    fillColor = UIColor.clearColor()
    strokeColor = UIColor.clearColor()
    
    // Button
    buttonFace.fillColor = UIColor(white: 0, alpha: 0.5)
    buttonFace.strokeColor = UIColor.clearColor()
    addChild(buttonFace)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
