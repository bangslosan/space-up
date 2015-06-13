//
//  PreloadHelper.swift
//  SpaceUp
//
//  Created by David Chin on 14/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

func preloadTextures(textures: [SKTexture]?, textureAtlases: [SKTextureAtlas]?, completion: () -> Void) {
  SKTextureAtlas.preloadTextureAtlases(textureAtlases ?? [SKTextureAtlas]()) {
    SKTexture.preloadTextures(textures ?? [SKTexture]()) {
      dispatch_async(dispatch_get_main_queue()) {
        completion()
      }
    }
  }
}
