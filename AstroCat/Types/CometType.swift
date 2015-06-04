//
//  CometType.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

enum CometType {
  case Regular
  case Slow
  case Fast
  case Award
  
  static func randomType(#levelFactor: CGFloat) -> CometType {
    var types = [CometType]()
    
    for i in 0..<5 {
      types << .Regular
    }
    
    for i in 0..<Int(round(levelFactor * 5)) {
      types << .Slow
      types << .Fast
      types << .Award
    }
    
    return types.sample()!
  }
}
