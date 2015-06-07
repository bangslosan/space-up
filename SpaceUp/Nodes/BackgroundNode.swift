//
//  BackgroundNode.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class BackgroundNode: SKSpriteNode {
  var imageName: String?
  
  init(imageNamed imageName: String) {
    let texture = SKTexture(imageNamed: imageName)
    
    self.imageName = imageName
    
    super.init(texture: texture, color: nil, size: texture.size())
    
    anchorPoint = CGPointZero
  }
  
  init(color: UIColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
