//
//  ModalView.swift
//  SpaceUp
//
//  Created by David Chin on 22/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class ModalView: SKNode {
  // MARK: - Immutable var
  let overlay: ModalOverlayNode
  let modal = SKNode()
  let modalBackground: ModalBackgroundNode

  // MARK: - Init
  init(size: CGSize) {
    overlay = ModalOverlayNode(rectOfSize: SceneSize)
    modalBackground = ModalBackgroundNode(size: size)

    super.init()
    
    // Layer
    zPosition = 100
    
    // Modal overlay
    addChild(overlay)
    
    // Modal
    addChild(modal)
    
    // Modal background
    modalBackground.position = CGPoint(x: overlay.frame.midX, y: overlay.frame.midY)
    modalBackground.userInteractionEnabled = false
    modalBackground.zPosition = -1
    modal.addChild(modalBackground)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Appear
  func appear(completion: (() -> Void)? = nil) {
    let startPosition = CGPoint(x: 0, y: -overlay.frame.height)
    let endPosition = CGPoint(x: 0, y: 0)
    let moveEffect = SKTMoveEffect(node: modal, duration: 0.6, startPosition: startPosition, endPosition: endPosition)
    
    moveEffect.timingFunction = SKTTimingFunctionBackEaseInOut
    overlay.alpha = 0
    modal.alpha = 0
    
    overlay.runAction(SKAction.fadeInWithDuration(0.6))
    modal.runAction(SKAction.group([
      SKAction.actionWithEffect(moveEffect),
      SKAction.fadeInWithDuration(0)
      ])) {
        completion?()
    }
  }
  
  func disappear(completion: (() -> Void)? = nil) {
    let startPosition = position
    let endPosition = CGPoint(x: 0, y: -overlay.frame.height)
    let moveEffect = SKTMoveEffect(node: modal, duration: 1, startPosition: startPosition, endPosition: endPosition)
    
    moveEffect.timingFunction = SKTTimingFunctionBackEaseInOut
    
    overlay.runAction(SKAction.fadeOutWithDuration(0.6))
    modal.runAction(SKAction.actionWithEffect(moveEffect)) {
      completion?()
    }
  }
}
