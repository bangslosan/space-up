//
//  ButtonNode.swift
//  SpaceUp
//
//  Created by David Chin on 24/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class ButtonNode: SKShapeNode {
  // MARK: - Vars
  weak var delegate: ButtonDelegate?
  private(set) var touchCount: UInt = 0
  
  var isTouched: Bool = false {
    didSet {
      if isTouched {
        delegate?.touchBeganForButton?(self)
      } else {
        delegate?.touchEndedForButton?(self)
      }
    }
  }
  
  // MARK: - Init
  override init() {
    super.init()
    
    // Interaction
    userInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIResponder
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    if let touch = touches.first as? UITouch {
      let touchLocation = touch.locationInNode(self)
      
      isTouched = true
      
      touchCount++
    }
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    isTouched = false
  }
  
  override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
    isTouched = false
  }
  
  // MARK: - Touch count
  func resetTouchCount() {
    touchCount = 0
  }
}
