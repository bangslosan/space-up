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
  
  static func randomType(levelFactor levelFactor: CGFloat, exceptTypes: [CometType]? = nil) -> CometType {
    var types = [CometType]()
    
    for _ in 0..<5 {
      types << .Regular
    }
    
    for _ in 0..<Int(round(levelFactor * 5)) {
      types << .Slow
      types << .Fast
      types << .Award
    }
    
    if let exceptTypes = exceptTypes {
      types = types.filter { !exceptTypes.contains($0) }
    }
    
    return types.sample() ?? .Regular
  }
}
