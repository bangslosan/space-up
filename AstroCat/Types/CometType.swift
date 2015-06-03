//
//  CometType.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import Foundation

enum CometType {
  case Regular
  case Slow
  case Fast
  case Award
  
  static func randomType() -> CometType {
    var types = [CometType]()
    
    for i in 1...5 {
      types << .Regular
    }
    
    types << .Slow
    types << .Fast
    types << .Award
    
    return types.sample()!
  }
}
