//
//  WorldDelegate.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

@objc protocol WorldDelegate {
  optional func world(world: WorldNode, didMoveFromPosition: CGPoint) -> Void
}
