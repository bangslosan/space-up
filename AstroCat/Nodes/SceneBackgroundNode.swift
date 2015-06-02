//
//  SceneBackgroundNode.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class SceneBackgroundNode: SKNode {
  weak var world: WorldNode?
  
  let galaxyForeground = EndlessBackgroundNode(imageNames: ["BackgroundFront0"])
  let galaxyBackground = EndlessBackgroundNode(imageNames: ["BackgroundBack0"])
  
  // MARK: - Init
  override init() {
    super.init()
    
    addChild(galaxyForeground)
    addChild(galaxyBackground)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Update
  func move(position: CGPoint) {
    galaxyForeground.move(position, multiplier: 0.8)
    galaxyBackground.move(position, multiplier: 0.6)
  }
}
