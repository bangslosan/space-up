//
//  SpriteButtonNode.swift
//  SpaceUp
//
//  Created by David Chin on 13/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class SpriteButtonNode: ButtonNode {
  private var textures = [ButtonState: SKTexture]()
  
  var state: ButtonState = .Normal {
    didSet {
      if let texture = textures[state] {
        self.texture = texture
      }
    }
  }
  
  // MARK: - Init
  convenience init(imageNamed imageName: String) {
    self.init(texture: SKTexture(imageNamed: imageName))
  }

  init(texture: SKTexture?) {
    super.init(texture: texture, color: nil, size: texture.size())
    
    setTexture(texture, forState: .Normal)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - State
  func setTexture(texture: SKTexture, forState state: ButtonState) {
    textures[state] = texture
  }
}
