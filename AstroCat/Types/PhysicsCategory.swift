//
//  PhysicsCategory.swift
//  AstroCat
//
//  Created by David Chin on 19/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import Foundation

struct PhysicsCategory {
  static let None: UInt32 = 0
  static let Player: UInt32 = 0x1 << 1
  static let Food: UInt32 = 0x1 << 2
  static let Comet: UInt32 = 0x1 << 3
  static let Ground: UInt32 = 0x1 << 4
  static let Boundary: UInt32 = 0x1 << 5
}
