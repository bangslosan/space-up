//
//  PauseMenuView.swift
//  SpaceUp
//
//  Created by David Chin on 26/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class PauseMenuView: ModalView {
  // MARK: - Immutable var
  let resumeButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonResume)
  let quitButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonHome)
  let soundButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonSound)
  let musicButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonMusic)
  
  // MARK: - Init
  init() {
    super.init(size: CGSize(width: 640, height: 540))
    
    // Resume
    resumeButton.position = CGPoint(x: modalBackground.frame.midX, y: modalBackground.frame.maxY - 200)
    modal.addChild(resumeButton)
    
    // Sound
    soundButton.position = CGPoint(x: modalBackground.frame.minX + 130, y: modalBackground.frame.minY + 200)
    soundButton.setTexture(SKTexture(imageNamed: TextureFileName.ButtonSoundOff), forState: .Active)
    soundButton.state = isSoundEnabled() ? .Normal : .Active
    modal.addChild(soundButton)
    
    // Music
    musicButton.position = CGPoint(x: modalBackground.frame.maxX - 130, y: modalBackground.frame.minY + 200)
    musicButton.setTexture(SKTexture(imageNamed: TextureFileName.ButtonMusicOff), forState: .Active)
    musicButton.state = isMusicEnabled() ? .Normal : .Active
    modal.addChild(musicButton)
    
    // Quit
    quitButton.position = CGPoint(x: modalBackground.frame.midX, y: modalBackground.frame.minY + 130)
    modal.addChild(quitButton)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
