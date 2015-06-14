//
//  StartSceneDelegate.swift
//  SpaceUp
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

@objc protocol StartSceneDelegate {
  optional func startSceneDidRequestStart(startScene: StartScene)
  optional func startSceneDidRequestLeaderboard(startScene: StartScene)
  optional func startSceneDidRequestToggleSound(startScene: StartScene, withButton button: SpriteButtonNode)
  optional func startSceneDidRequestToggleMusic(startScene: StartScene, withButton button: SpriteButtonNode)
}
