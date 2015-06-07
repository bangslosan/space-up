//
//  SKActionExtension.swift
//  SpaceUp
//
//  Created by David Chin on 23/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

extension SKAction {
  class func moveTo(location: CGPoint, duration sec: NSTimeInterval, timingMode: SKActionTimingMode) -> SKAction {
    let action = moveTo(location, duration: sec)

    action.timingMode = timingMode
  
    return action
  }
}
