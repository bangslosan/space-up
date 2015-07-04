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
}

class TapTipNode: SKSpriteNode {
  // MARK: - Init
  init() {
    let texture = SKTexture(imageNamed: TextureFileName.TapTip)
    
    super.init(texture: texture, color: nil, size: texture.size())
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

    runAction(fadeInAction, withKey: KeyForAction.appearAction)
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
    
    runAction(SKAction.sequence([
      fadeOutAction,
      removeAction,
      SKAction.runBlock { completion?() }
    ]), withKey: KeyForAction.disappearAction)
  }
}
