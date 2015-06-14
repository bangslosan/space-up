//
//  PauseMenuView.swift
//  SpaceUp
//
//  Created by David Chin on 26/05/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class PauseMenuView: SKNode {
  // MARK: - Immutable var
  let background: SKShapeNode
  let modalBackground = ModalBackgroundNode(size: CGSize(width: 640, height: 540))
  let resumeButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonResume)
  let quitButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonHome)
  let soundButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonSound)
  let musicButton = SpriteButtonNode(imageNamed: TextureFileName.ButtonMusic)
  
  // MARK: - Init
  init(size: CGSize) {
    background = SKShapeNode(rectOfSize: size)

    super.init()
    
    // Background
    background.fillColor = UIColor(white: 0, alpha: 0.5)
    background.strokeColor = UIColor.clearColor()
    background.position = CGPoint(x: background.frame.width / 2, y: background.frame.height / 2)
    background.userInteractionEnabled = false
    background.zPosition = -1
    addChild(background)
    
    // Modal background
    modalBackground.position = CGPoint(x: background.frame.midX, y: background.frame.midY)
    modalBackground.userInteractionEnabled = false
    modalBackground.zPosition = -1
    addChild(modalBackground)
    
    // Resume
    resumeButton.position = CGPoint(x: modalBackground.frame.midX, y: modalBackground.frame.maxY - 200)
    addChild(resumeButton)
    
    // Sound
    soundButton.position = CGPoint(x: modalBackground.frame.minX + 130, y: modalBackground.frame.minY + 200)
    soundButton.setTexture(SKTexture(imageNamed: TextureFileName.ButtonSoundOff), forState: .Active)
    soundButton.state = isSoundEnabled() ? .Normal : .Active
    addChild(soundButton)
    
    // Music
    musicButton.position = CGPoint(x: modalBackground.frame.maxX - 130, y: modalBackground.frame.minY + 200)
    musicButton.setTexture(SKTexture(imageNamed: TextureFileName.ButtonMusicOff), forState: .Active)
    musicButton.state = isMusicEnabled() ? .Normal : .Active
    addChild(musicButton)
    
    // Quit
    quitButton.position = CGPoint(x: modalBackground.frame.midX, y: modalBackground.frame.minY + 130)
    addChild(quitButton)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
