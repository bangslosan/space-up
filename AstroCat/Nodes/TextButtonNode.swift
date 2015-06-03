//
//  TextButtonNode.swift
//  AstroCat
//
//  Created by David Chin on 26/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class TextButtonNode: ButtonNode {
  // MARK: - Immutable vars
  let label = SKLabelNode(fontNamed: "HelveticaNeue")

  // MARK: - Init
  init(size: CGSize) {
    super.init()

    // Shape
    let rect = CGRect(origin: CGPoint(x: size.width / -2, y: size.height / -2), size: size)
    path = CGPathCreateWithRect(rect, nil)
    
    // Fill color
    fillColor = UIColor(white: 0, alpha: 0.2)
    strokeColor = UIColor.clearColor()
    
    // Label
    label.fontSize = 30
    label.color = UIColor.blackColor()
    label.colorBlendFactor = 1
    label.horizontalAlignmentMode = .Center
    label.verticalAlignmentMode = .Center
    addChild(label)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
