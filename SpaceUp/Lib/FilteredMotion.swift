//
//  FilteredMotion.swift
//  SpaceUp
//
//  Created by David Chin on 12/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit
import CoreMotion

class FilteredMotion {
  // MARK: - Vars
  lazy private(set) var acceleration = CMAcceleration(x: 0, y: 0, z: 0)
  lazy private(set) var rotationRate = CMRotationRate(x: 0, y: 0, z: 0)
  var factor: Double = 0
  var type: SamplingFilterType = .None
  
  init() {}
  
  convenience init(type: SamplingFilterType, factor: Double) {
    self.init()

    self.type = type
    self.factor = factor
  }
  
  func updateAcceleration(originalAcceleration: CMAcceleration) {
    switch type {
    case .HighPass:
      acceleration.x = originalAcceleration.x - (acceleration.x * factor + acceleration.x * (1 - factor))
      acceleration.y = originalAcceleration.y - (acceleration.y * factor + acceleration.y * (1 - factor))
      acceleration.z = originalAcceleration.z - (acceleration.z * factor + acceleration.z * (1 - factor))
    case .LowPass:
      acceleration.x = originalAcceleration.x * factor + acceleration.x * (1 - factor)
      acceleration.y = originalAcceleration.y * factor + acceleration.y * (1 - factor)
      acceleration.z = originalAcceleration.z * factor + acceleration.z * (1 - factor)
    case .None:
      acceleration.x = originalAcceleration.x
      acceleration.y = originalAcceleration.y
      acceleration.z = originalAcceleration.z
    }
    
    switch UIApplication.sharedApplication().statusBarOrientation {
    case .LandscapeRight, .PortraitUpsideDown:
      acceleration.y *= -1
      acceleration.x *= -1
    default:
      break
    }
  }
  
  func updateRotationRate(originalRotationRate: CMRotationRate) {
    switch type {
    case .HighPass:
      rotationRate.x = originalRotationRate.x - (rotationRate.x * factor + rotationRate.x * (1 - factor))
      rotationRate.y = originalRotationRate.y - (rotationRate.y * factor + rotationRate.y * (1 - factor))
      rotationRate.z = originalRotationRate.z - (rotationRate.z * factor + rotationRate.z * (1 - factor))
    case .LowPass:
      rotationRate.x = originalRotationRate.x * factor + rotationRate.x * (1 - factor)
      rotationRate.y = originalRotationRate.y * factor + rotationRate.y * (1 - factor)
      rotationRate.z = originalRotationRate.z * factor + rotationRate.z * (1 - factor)
    case .None:
      rotationRate.x = originalRotationRate.x
      rotationRate.y = originalRotationRate.y
      rotationRate.z = originalRotationRate.z
    }
    
    if UIApplication.sharedApplication().statusBarOrientation == .LandscapeRight {
      rotationRate.y *= -1
      rotationRate.x *= -1
    }
  }
}
