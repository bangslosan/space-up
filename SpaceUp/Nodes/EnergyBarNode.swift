//
//  EnergyBarNode.swift
//  SpaceUp
//
//  Created by David Chin on 10/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class EnergyBarNode: SKShapeNode {
  let mask = SKCropNode()
  let valueBar: SKShapeNode

  // MARK: - Init
  init(size: CGSize) {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let radius = rect.height / 2
    
    valueBar = SKShapeNode(rect: rect)

    super.init()

    // Fill
    path = CGPathCreateWithRect(rect, nil)
    fillColor = UIColor.blackColor()
    strokeColor = UIColor.clearColor()
    
    // Bar
    valueBar.fillColor = UIColor.greenColor()
    valueBar.strokeColor = UIColor.clearColor()
    
    // Mask
    let maskRect = CGRect(x: rect.origin.x + 1, y: rect.origin.y + 1, width: rect.width - 2, height: rect.height - 2)
    let maskShape = SKShapeNode(rect: maskRect)
    mask.maskNode = maskShape
    mask.addChild(valueBar)
    addChild(mask)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Size
  func updateEnergy(energy: CGFloat) {
    valueBar.runAction(SKAction.scaleXTo(energy, duration: 0))
  }
  
  func reset() {
    updateEnergy(1)
  }
}
