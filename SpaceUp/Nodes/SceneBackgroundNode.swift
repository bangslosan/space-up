//
//  SceneBackgroundNode.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class SceneBackgroundNode: SKNode {
  weak var world: WorldNode?
  
  private let galaxyBackground = EndlessBackgroundNode(imageNames: [TextureFileName.Background])
  private let galaxyStars = EndlessBackgroundNode(imageNames: [TextureFileName.BackgroundStars])
  private let galaxyLargePlanets = EndlessBackgroundNode(imageNames: [
    TextureFileName.BackgroundLargePlanets,
    TextureFileName.BackgroundLargePlanets + "2"
  ])
  private let galaxySmallPlanets = EndlessBackgroundNode(imageNames: [
    TextureFileName.BackgroundSmallPlanets,
    TextureFileName.BackgroundSmallPlanets + "2"
  ])
  
  // MARK: - Init
  override init() {
    super.init()
    
    addChild(galaxyBackground)
    addChild(galaxyStars)
    addChild(galaxySmallPlanets)
    addChild(galaxyLargePlanets)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Update
  func move(position: CGPoint) {
    galaxyBackground.move(position, multiplier: 0.4)
    galaxyStars.move(position, multiplier: 0.5)
    galaxySmallPlanets.move(position, multiplier: 0.6)
    galaxyLargePlanets.move(position, multiplier: 0.7)
  }
}
