//
//  GameDataSource.swift
//  SpaceUp
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import Foundation

protocol GameDataSource: class {
  var gameData: GameData { get }
}
