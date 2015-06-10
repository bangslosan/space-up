//
//  CometType.swift
//  SpaceUp
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
  case Fuel
  
  static func randomType(#levelFactor: CGFloat, exceptTypes: [CometType]? = nil) -> CometType {
    var types = [CometType]()
    
    for i in 0..<5 {
      types << .Regular
    }
    
    for i in 0..<Int(round(levelFactor * 5)) {
      types << .Slow
      types << .Fast
      types << .Award
    }
    
    if let exceptTypes = exceptTypes {
      types = types.filter { !contains(exceptTypes, $0) }
    }
    
    return types.sample() ?? .Regular
  }
}
