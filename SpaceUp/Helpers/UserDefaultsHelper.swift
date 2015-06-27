//
//  UserDefaultsHelper.swift
//  SpaceUp
//
//  Created by David Chin on 7/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import Foundation

func isSoundEnabled() -> Bool {
  let userDefaults = NSUserDefaults.standardUserDefaults()

  return userDefaults.boolForKey(KeyForUserDefaults.SoundDisabled) != true
}

func isMusicEnabled() -> Bool {
  let userDefaults = NSUserDefaults.standardUserDefaults()

  return userDefaults.boolForKey(KeyForUserDefaults.MusicDisabled) != true
}

func isAdsEnabled() -> Bool {
  let userDefaults = NSUserDefaults.standardUserDefaults()
  
  return userDefaults.boolForKey(ProductIdentifier.RemoveAds) != true
}
