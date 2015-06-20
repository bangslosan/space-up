//
//  SphereHighlight.swift
//  SpaceUp
//
//  Created by David Chin on 20/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class SphereHighlightNode: SKShapeNode {
  init(radius: CGFloat) {
    let center = CGPointZero
    let startAngle = CGFloat(45).degreesToRadians()
    let endAngle = CGFloat(225).degreesToRadians()
    let endPoint = CGPoint(x: center.x + (radius * sin(startAngle)), y: center.y + (radius * cos(startAngle)))
    let controlPoint = CGPoint(x: radius / 2, y: radius / -2)
    let bezierPath = UIBezierPath()
    
    bezierPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    bezierPath.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
    
    super.init()
    
    path = bezierPath.CGPath
    strokeColor = UIColor.clearColor()
    fillColor = UIColor.whiteColor()
    blendMode = SKBlendMode.Add
    alpha = 0.08
    zPosition = 100
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
