//
//  GameData.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForCoder {
  static let topScore = "topScore"
  static let score = "score"
  static let energy = "energy"
  static let foodCount = "foodCount"
  static let gameOver = "gameOver"
  static let shouldUpdate = "shouldUpdate"
}

private let fileURL: NSURL = {
  return NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, withPathComponent: GameDataArchiveName)
}()

class GameData: NSObject, NSCoding {
  private(set) var topScore: CGFloat = 0

  private(set) var score: CGFloat = 0 {
    didSet {
      score = max(score, 0)
    }
  }
  
  private(set) var energy: CGFloat = 1 {
    didSet {
      energy = energy.clamped(0, 1)
    }
  }
  
  // MARK: - Computed vars
  var level: UInt {
    let base: CGFloat = 1.1
    let offset: CGFloat = 100 // 30
    let exponent = log((score + offset) / offset) / log(base)
    
    return 1 + UInt(round(exponent))
  }
  
  var levelFactor: CGFloat {
    let maxLevel: UInt = 20

    return CGFloat(min(level, maxLevel)) / CGFloat(maxLevel)
  }
  
  // MARK: - Init
  class func dataFromArchive() -> GameData {
    if let data = NSData(contentsOfURL: fileURL),
      gameData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GameData {
        return gameData
    }
    
    return GameData()
  }

  override init() {
    super.init()
  }
  
  required init(coder aDecoder: NSCoder) {
    if aDecoder.containsValueForKey(KeyForCoder.topScore) {
      topScore = CGFloat(aDecoder.decodeFloatForKey(KeyForCoder.topScore))
    }
    
    if aDecoder.containsValueForKey(KeyForCoder.score) {
      score = CGFloat(aDecoder.decodeFloatForKey(KeyForCoder.score))
    }
    
    if aDecoder.containsValueForKey(KeyForCoder.energy) {
      energy = CGFloat(aDecoder.decodeFloatForKey(KeyForCoder.energy))
    }
  }
  
  // MARK: - NSCoding
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeFloat(Float(topScore), forKey: KeyForCoder.topScore)
    aCoder.encodeFloat(Float(score), forKey: KeyForCoder.score)
    aCoder.encodeFloat(Float(energy), forKey: KeyForCoder.energy)
  }
  
  func saveToArchive() {
    let data = NSKeyedArchiver.archivedDataWithRootObject(self)
    
    data.writeToURL(fileURL, atomically: true)
  }
  
  // MARK: - Update
  func updateTopScore() {
    topScore = max(score, topScore)
  }

  func updateScoreForPlayer(player: PlayerNode) {
    score = max(player.distanceTravelled / 100, score)
  }
  
  func decrementEnergy() {
    energy -= 0.001
  }
  
  func restoreEnergy(amount: CGFloat = 0.2) {
    energy += amount
  }

  func reset() {
    score = 0
    energy = 1
  }
}
