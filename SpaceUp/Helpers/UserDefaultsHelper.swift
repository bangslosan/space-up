//
//  UserDefaultsHelper.swift
//  SpaceUp
//
//  Created by David Chin on 7/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import Foundation

func isSoundEnabled() -> Bool {
  return NSUserDefaults.standardUserDefaults().boolForKey(KeyForUserDefaults.SoundDisabled) != true
}

func isMusicEnabled() -> Bool {
  return NSUserDefaults.standardUserDefaults().boolForKey(KeyForUserDefaults.MusicDisabled) != true
}
