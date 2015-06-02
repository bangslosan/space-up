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
      topScore = max(score, topScore)
    }
  }
  
  private(set) var energy: CGFloat = 1 {
    didSet {
      energy = energy.clamped(0, 1)
    }
  }
  
  private(set) var foodCount: UInt = 0
  
  var shouldUpdate = false
  var gameOver = false
  
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
    
    if aDecoder.containsValueForKey(KeyForCoder.energy) {
      energy = CGFloat(aDecoder.decodeFloatForKey(KeyForCoder.energy))
    }
    
    if aDecoder.containsValueForKey(KeyForCoder.foodCount) {
      foodCount = UInt(aDecoder.decodeIntegerForKey(KeyForCoder.foodCount))
    }
    
    if aDecoder.containsValueForKey(KeyForCoder.gameOver) {
      gameOver = aDecoder.decodeBoolForKey(KeyForCoder.gameOver)
    }
    
    if aDecoder.containsValueForKey(KeyForCoder.shouldUpdate) {
      shouldUpdate = aDecoder.decodeBoolForKey(KeyForCoder.shouldUpdate)
    }
  }
  
  // MARK: - NSCoding
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeBool(gameOver, forKey: KeyForCoder.gameOver)
    aCoder.encodeBool(shouldUpdate, forKey: KeyForCoder.shouldUpdate)
    aCoder.encodeFloat(Float(energy), forKey: KeyForCoder.energy)
    aCoder.encodeFloat(Float(score), forKey: KeyForCoder.score)
    aCoder.encodeFloat(Float(topScore), forKey: KeyForCoder.topScore)
    aCoder.encodeInteger(Int(foodCount), forKey: KeyForCoder.foodCount)
  }
  
  func saveToArchive() {
    let data = NSKeyedArchiver.archivedDataWithRootObject(self)
    
    data.writeToURL(fileURL, atomically: true)
  }
  
  // MARK: - Update
  func update() {
    decreaseEnergy()
  }
  
  func reset() {
    energy = 1
    score = 0
    foodCount = 0
    shouldUpdate = false
  }
  
  // MARK: - Food
  func consumeFood(food: FoodNode) {
    increaseEnergy()
    increaseFoodCount()
    increaseScore()
  }
  
  // MARK: - Energy
  func decreaseEnergy() {
    let factor: CGFloat = 0.0001
    
    energy -= CGFloat(level) * factor
  }
  
  func increaseEnergy() {
    let factor: CGFloat = 0.02
    
    energy += 0.1 + CGFloat(level) * factor
  }
  
  // MARK: - Score
  func increaseScore() {
    score += 1
  }
  
  func increaseFoodCount() {
    foodCount += 1
  }
}
