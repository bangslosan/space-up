//
//  SpriteKitFunctions.swift
//  AstroCat
//
//  Created by David Chin on 3/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

func nodeInContact(contact: SKPhysicsContact, withCategoryBitMask categoryBitMask: UInt32) -> SKNode? {
  // NOTE: Having trouble writing an extension for SKPhysicsContact (resulting unrecognized selector runtime error)
  let bodies = [contact.bodyA, contact.bodyB]
  
  return nodeWithCategoryBitMask(categoryBitMask, inBodies: bodies)
}

func nodeWithCategoryBitMask(categoryBitMask: UInt32, inBodies bodies: [SKPhysicsBody!]) -> SKNode? {
  for body in bodies {
    if body.categoryBitMask & categoryBitMask == categoryBitMask {
      return body.node
    }
  }
  
  return nil
}

func areBits(bits: UInt32, setWithBits otherBits: UInt32) -> Bool {
  return bits & otherBits == otherBits
}
