//
//  Constants.swift
//  AstroCat
//
//  Created by David Chin on 18/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit

// MARK: - Size
let SceneSize = CGSize(width: 768, height: 1024)
let WorldArea = CGRect(x: 0, y: 0, width: SceneSize.width * 2, height: SceneSize.height)

// MARK: - Notification
let DidRequestStartGameNotification = "DidRequestStartGameNotification"
let DidRequestQuitGameNotification = "DidRequestQuitGameNotification"
let DidPauseGameNotification = "DidPauseGameNotification"
let DidResumeGameNotification = "DidResumeGameNotification"

// MARK: - Archive
let GameDataArchiveName = "GameData"
