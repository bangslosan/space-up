//
//  MathHelper.swift
//  SpaceUp
//
//  Created by David Chin on 5/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

func pointBetweenPoint(pointA: CGPoint, andPoint pointB: CGPoint) -> CGPoint {
  return CGPoint(x: (pointA.x + pointB.x) / 2, y: (pointA.y + pointB.y) / 2)
}

func lineFromPoint(fromPoint: CGPoint, #toPoint: CGPoint)(pointAtX x: CGFloat) -> CGPoint {
  let slope = (toPoint.y - fromPoint.y) / (toPoint.x - fromPoint.x)
  let yIntercept = fromPoint.y - slope * fromPoint.x
  let y = slope * x + yIntercept
  
  return CGPoint(x: x, y: y)
}

func lineFromPoint(fromPoint: CGPoint, #toPoint: CGPoint)(pointAtY y: CGFloat) -> CGPoint {
  let slope = (toPoint.y - fromPoint.y) / (toPoint.x - fromPoint.x)
  let yIntercept = fromPoint.y - slope * fromPoint.x
  let x = (y - yIntercept) / slope
  
  return CGPoint(x: x, y: y)
}
