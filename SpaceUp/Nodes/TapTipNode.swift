//
//  TapTipNode.swift
//  SpaceUp
//
//  Created by David Chin on 3/07/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

private struct KeyForAction {
  static let appearAction = "appearAction"
  static let disappearAction = "disappearAction"
  static let upDownAction = "upDownAction"
}

class TapTipNode: SKNode {
  let hand = SKSpriteNode(imageNamed: TextureFileName.TapTip)
  let textLabel = ShadowLabelNode(fontNamed: FontName.RegularFont)
  
  private lazy var upDownRepeatAction: SKAction = {
    let upDownAction = SKAction.sequence([
      SKAction.moveByX(0, y: 30, duration: 0.5, timingMode: .EaseInEaseOut),
      SKAction.moveByX(0, y: -30, duration: 0.5, timingMode: .EaseInEaseOut),
    ])
    
    return SKAction.repeatActionForever(upDownAction)
  }()

  // MARK: - Init
  override init() {
    super.init()
    
    hand.anchorPoint = CGPoint(x: 0.5, y: 0)
    addChild(hand)
    
    textLabel.position = CGPoint(x: 0, y: -50)
    textLabel.text = "Touch to start"
    addChild(textLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Appear
  func appearWithDuration(duration: NSTimeInterval) {
    if hasActionForKey(KeyForAction.appearAction) {
      return
    }

    let fadeInAction = SKAction.fadeInWithDuration(duration)
    
    fadeInAction.timingMode = .EaseOut

    // Run
    runAction(fadeInAction, withKey: KeyForAction.appearAction)
    hand.runAction(upDownRepeatAction, withKey: KeyForAction.upDownAction)
  }
  
  func removeWithDuration(duration: NSTimeInterval, completion: (() -> Void)? = nil) {
    if hasActionForKey(KeyForAction.disappearAction) {
      return
    }
    
    let fadeOutAction = SKAction.fadeOutWithDuration(duration)
    let removeAction = SKAction.runBlock { [weak self] in
      self?.removeFromParentIfNeeded()
    }
    
    fadeOutAction.timingMode = .EaseOut
    
    // Run
    runAction(SKAction.sequence([
      fadeOutAction,
      removeAction,
      SKAction.runBlock {
        self.removeActionForKey(KeyForAction.upDownAction)
        completion?()
      }
    ]), withKey: KeyForAction.disappearAction)
  }
}
