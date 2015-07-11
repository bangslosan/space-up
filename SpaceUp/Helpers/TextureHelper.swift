//
//  TextureHelper.swift
//  SpaceUp
//
//  Created by David Chin on 11/07/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

func texturesWithName(name: String, #fromIndex: Int, #toIndex: Int) -> [SKTexture] {
  return texturesWithName(name, fromIndex: fromIndex, toIndex: toIndex, reversed: false)
}

func texturesWithName(name: String, #fromIndex: Int, #toIndex: Int, #reversed: Bool) -> [SKTexture] {
  var textures = [SKTexture]()
  
  for (_, index) in enumerate(fromIndex...toIndex) {
    textures << SKTexture(imageNamed: name, index: index)
  }
  
  if reversed {
    for (_, index) in enumerate(fromIndex...toIndex) {
      textures << SKTexture(imageNamed: name, index: toIndex - index + fromIndex)
    }
  }
  
  return textures
}
