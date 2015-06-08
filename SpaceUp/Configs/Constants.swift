//
//  Constants.swift
//  SpaceUp
//
//  Created by David Chin on 18/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit

// MARK: - Domain
let MainBundleIdentifier = NSBundle.mainBundle().bundleIdentifier!

// MARK: - Size
let SceneSize = CGSize(width: 720, height: 1280) // CGSize(width: 768, height: 1024)
let WorldArea = CGRect(x: 0, y: 0, width: SceneSize.width * 2, height: SceneSize.height)

// MARK: - Emitter
let EmitterVerticalSpacing: CGFloat = 450

// MARK: - Archive
let GameDataArchiveName = "GameData"

// MARK: - iAd
let MinimumNumberOfRetriesBeforePresentingAd: UInt = 3
