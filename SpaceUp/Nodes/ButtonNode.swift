//
//  ButtonNode.swift
//  SpaceUp
//
//  Created by David Chin on 24/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
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
  
  // private lazy var tapSoundAction = SKAction.playSoundFileNamed(SoundFileName.Button, waitForCompletion: false)
  
  // MARK: - Init
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
    
    // Interaction
    userInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIResponder
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    isTouched = true
    
    touchCount++
    
    // Sound
    playTapSoundIfNeeded()
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    isTouched = false
  }
  
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    isTouched = false
  }

  // MARK: - Touch count
  func resetTouchCount() {
    touchCount = 0
  }
  
  // MARK: - Sound
  private func playTapSoundIfNeeded() {
    if isSoundEnabled() {
      SKTAudio.sharedInstance().playSoundEffect(SoundFileName.Button, volume: 0.3)
    }
  }
}
