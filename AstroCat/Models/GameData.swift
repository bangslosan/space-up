//
//  GameData.swift
//  AstroCat
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
  
  // MARK: - Computed vars
  class var sharedGameData: GameData {
    struct Static {
      static let instance = GameData.dataFromArchive()
    }
    
    return Static.instance
  }
  
  class func dataFromArchive() -> GameData {
    if let data = NSData(contentsOfURL: fileURL),
      gameData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GameData {
        return gameData
    }
    
    return GameData()
  }
  
  var level: UInt {
    let base: CGFloat = 1.1
    let exponent = log((score + 100) / 100) / log(base)
    
    return 1 + UInt(round(exponent))
  }
  
  // MARK: - Init
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
  }
  
  // MARK: - NSCoding
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeFloat(Float(topScore), forKey: KeyForCoder.topScore)
    aCoder.encodeFloat(Float(score), forKey: KeyForCoder.score)
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
    score = max(player.distanceTravelled, score)
  }

  func reset() {
    score = 0
  }
}
