//
//  GameSceneDelegate.swift
//  AstroCat
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

@objc protocol GameSceneDelegate {
  optional func gameScene(gameScene: GameScene, didEndGameWithScore score: CGFloat)
}
