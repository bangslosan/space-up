//
//  Constants.swift
//  AstroCat
//
//  Created by David Chin on 18/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit

// MARK: - Domain
let MainBundleIdentifier = NSBundle.mainBundle().bundleIdentifier!

// MARK: - Size
let SceneSize = CGSize(width: 768, height: 1024)
let WorldArea = CGRect(x: 0, y: 0, width: SceneSize.width * 2, height: SceneSize.height)

// MARK: - Notification
let DidRequestStartGameNotification = "DidRequestStartGameNotification"
let DidRequestQuitGameNotification = "DidRequestQuitGameNotification"
let DidRequestLeaderboardNotification = "DidRequestLeaderboardNotification"
let DidPauseGameNotification = "DidPauseGameNotification"
let DidResumeGameNotification = "DidResumeGameNotification"
let DidEndGameNotifiation = "DidEndGameNotifiation"

// MARK: - Archive
let GameDataArchiveName = "GameData"
