//
//  IconButtonNode.swift
//  SpaceUp
//
//  Created by David Chin on 26/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class IconButtonNode: ButtonNode {
  let buttonFace: SKShapeNode
  let iconLabel: SKLabelNode

  // MARK: - Init
  init(size: CGSize, text: String) {
    let rect = CGRect(x: -size.width / 2, y: -size.height / 2,  width: size.width, height: size.height)

    iconLabel = SKLabelNode(fontNamed: "FontAwesome")
    buttonFace = SKShapeNode(rect: rect, cornerRadius: 12)
    
    super.init(texture: nil, color: UIColor.clearColor(), size: size)
    
    // Button
    buttonFace.fillColor = UIColor(white: 0, alpha: 0.8)
    buttonFace.strokeColor = UIColor.clearColor()
    addChild(buttonFace)
    
    // Text
    iconLabel.text = text
    iconLabel.color = UIColor.whiteColor()
    iconLabel.colorBlendFactor = 1
    iconLabel.horizontalAlignmentMode = .Center
    iconLabel.verticalAlignmentMode = .Center
    iconLabel.fontSize = 30
    iconLabel.position = CGPoint(x: buttonFace.frame.midX, y: buttonFace.frame.midY)
    addChild(iconLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
