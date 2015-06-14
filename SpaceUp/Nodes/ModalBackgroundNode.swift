//
//  ModalBackgroundNode.swift
//  SpaceUp
//
//  Created by David Chin on 14/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class ModalBackgroundNode: SKShapeNode {
  let foreground: SKShapeNode

  // MARK: - Init
  init(size: CGSize) {
    let padding: CGFloat = 20

    foreground = SKShapeNode(rectOfSize: CGSize(width: size.width - padding * 2, height: size.height - padding * 2),
                             cornerRadius: 10)

    super.init()
    
    // Path
    path = CGPathCreateWithRoundedRect(CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height), 10, 10, nil)
    fillColor = UIColor(red: 41/255, green: 46/255, blue: 113/255, alpha: 0.3)
    strokeColor = UIColor.clearColor()
    
    // Foreground
    foreground.position = CGPoint(x: 0, y: 0)
    foreground.fillColor = UIColor(red: 41/255, green: 46/255, blue: 113/255, alpha: 1)
    foreground.strokeColor = UIColor.clearColor()
    foreground.userInteractionEnabled = false
    addChild(foreground)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
