//
//  EndlessBackgroundNode.swift
//  AstroCat
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class EndlessBackgroundNode: SKNode {
  // MARK: - Vars
  var backgrounds = [BackgroundNode]()
  var imageNames = [String]()
  
  init(imageNames: [String]) {
    self.imageNames = imageNames
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func move(position: CGPoint, multiplier: CGFloat) {
    self.position = position * CGPoint(x: multiplier, y: multiplier)
    
    updateIfNeeded()
  }
  
  func populate() {
    appendIfNeeded()
  }
  
  func appendIfNeeded() {
    if let scene = scene {
      var maxY: CGFloat = 0
      var index: Int = 0
      
      if let lastBackground = backgrounds.last {
        maxY = scene.convertFrame(lastBackground.frame, fromNode: self).maxY
        
        if let lastImageName = lastBackground.imageName, lastImageNameIndex = find(imageNames, lastImageName) {
          index = lastImageNameIndex + 1
        }
      }
      
      if maxY < scene.frame.maxY || backgrounds.last == nil {
        if let imageName = imageNameAtIndex(index) ?? imageNameAtIndex(0) {
          let newBackground = backgroundWithImageName(imageName)
          
          // Position
          if let lastBackground = backgrounds.last {
            newBackground.position = CGPoint(x: 0, y: lastBackground.frame.maxY)
          }
          
          // Append
          appendBackground(newBackground)
          
          // Increment
          // maxY = scene.convertFrame(newBackground.frame, fromNode: self).maxY
        }
      }
    }
  }
  
  func prependIfNeeded() {
    if let scene = scene {
      var minY: CGFloat = 0
      var index: Int = 0
      
      if let firstBackground = backgrounds.first {
        minY = scene.convertFrame(firstBackground.frame, fromNode: self).minY
        
        if let firstImageName = firstBackground.imageName, firstImageNameIndex = find(imageNames, firstImageName) {
          index = firstImageNameIndex - 1
        }
      }
      
      if minY > scene.frame.minY || backgrounds.first == nil {
        if let imageName = imageNameAtIndex(index) ?? imageNameAtIndex(backgrounds.count - 1) {
          let newBackground = backgroundWithImageName(imageName)
          
          // Position
          if let firstBackground = backgrounds.first {
            newBackground.position = CGPoint(x: 0, y: firstBackground.frame.minY - newBackground.frame.height)
          }
          
          // Prepend
          prependBackground(newBackground)
          
          // Increment
          // minY = scene.convertFrame(newBackground.frame, fromNode: self).minY
        }
      }
    }
  }
  
  func removeIfNeeded() {
    if let scene = scene {
      if let background = backgrounds.last {
        if scene.convertFrame(background.frame, fromNode: self).minY > scene.frame.maxY + scene.frame.height / 2 {
          removeBackground(background)
        }
      }

      if let background = backgrounds.first {
        if scene.convertFrame(background.frame, fromNode: self).maxY < scene.frame.minY - scene.frame.height / 2 {
          removeBackground(background)
        }
      }
    }
  }
  
  func updateIfNeeded() {
    appendIfNeeded()
    prependIfNeeded()
    removeIfNeeded()
  }
  
  private func imageNameAtIndex(index: Int) -> String? {
    return imageNames.pick(index)
  }
  
  private func appendBackground(background: BackgroundNode) {
    backgrounds.append(background)
    addChild(background)
  }
  
  private func prependBackground(background: BackgroundNode) {
    backgrounds.prepend(background)
    addChild(background)
  }
  
  private func removeBackground(background: BackgroundNode) {
    background.removeFromParent()
    removeObjectByReference(background, fromArray: &backgrounds)
  }
  
  private func backgroundWithImageName(imageName: String) -> BackgroundNode {
    let newBackground = BackgroundNode(imageNamed: imageName)
    
    newBackground.zPosition = -10
    newBackground.anchorPoint = CGPointZero
    
    return newBackground
  }
}
