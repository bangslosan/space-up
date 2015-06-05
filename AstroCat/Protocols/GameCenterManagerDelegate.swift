//
//  GameCenterManagerDelegate.swift
//  AstroCat
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit
import GameKit

@objc protocol GameCenterManagerDelegate {
  optional func gameCenterManager(manager: GameCenterManager, didProvideViewController viewController: UIViewController)
  optional func gameCenterManager(manager: GameCenterManager, didAuthenticateLocalPlayer: Bool)
  optional func gameCenterManager(manager: GameCenterManager, didLoadDefaultLeaderboardIdentifier identifier: String)
  optional func gameCenterManager(manager: GameCenterManager, didReportScore: GKScore)
  optional func gameCenterManager(manager: GameCenterManager, didReceiveError error: NSError)
}
