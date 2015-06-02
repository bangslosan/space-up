//
//  CGPointExtension.swift
//  AstroCat
//
//  Created by David Chin on 24/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

public extension CGPoint {
  func isFarFromPoint(point: CGPoint, minimumDistance: CGFloat = 0) -> Bool {
    return self.distanceTo(point) >= minimumDistance
  }
}
