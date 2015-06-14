//
//  GameSceneDelegate.swift
//  SpaceUp
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

@objc protocol GameSceneDelegate {
  optional func gameSceneDidRequestStart(gameScene: GameScene)
  optional func gameSceneDidRequestRetry(gameScene: GameScene)
  optional func gameSceneDidRequestQuit(gameScene: GameScene)
  optional func gameSceneDidRequestLeaderboard(gameScene: GameScene)
  optional func gameSceneDidRequestToggleSound(gameScene: GameScene, withButton button: SpriteButtonNode)
  optional func gameSceneDidRequestToggleMusic(gameScene: GameScene, withButton button: SpriteButtonNode)
  optional func gameSceneDidPause(gameScene: GameScene)
  optional func gameSceneDidResume(gameScene: GameScene)
  optional func gameSceneDidEnd(gameScene: GameScene)
  optional func gameSceneDidStart(gameScene: GameScene)
}
