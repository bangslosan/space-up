//
//  GameData.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit
import GameKit

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
  // MARK: - Vars
  private(set) var topScore: CGFloat = 0
  private(set) var score: CGFloat = 0 {
    didSet {
      score = max(score, 0)
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
  
  // MARK: - Transform value
  class func transformDistanceToScore(distance: CGFloat) -> CGFloat {
    return distance / 100
  }
  
  class func transformScoreToDistance(score: CGFloat) -> CGFloat {
    return score * 100
  }
  
  // MARK: - Update
  func updateTopScoreWithGKScore(score: GKScore) {
    topScore = CGFloat(score.value)
  }

  func updateTopScore() {
    topScore = max(score, topScore)
  }

  func updateScoreForPlayer(player: PlayerNode) {
    score = max(player.distanceTravelled / 100, score)
  }

  func reset() {
    score = 0
  }
}
