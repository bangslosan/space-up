//
//  SKTextureExtension.swift
//  SpaceUp
//
//  Created by David Chin on 11/07/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

extension SKTexture {
  convenience init(imageNamed name: String, index: Int) {
    self.init(imageNamed: "\(name)\(index)")
  }
}
