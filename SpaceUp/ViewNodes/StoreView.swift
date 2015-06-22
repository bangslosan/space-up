//
//  StoreView.swift
//  SpaceUp
//
//  Created by David Chin on 22/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

class StoreView: ModalView {
  // MARK: - Immutable var
  let closeButton = IconButtonNode(size: CGSize(width: 70, height: 70), text: "\u{f00d}")

  // MARK: - Init
  init() {
    super.init(size: CGSize(width: 640, height: 540))
    
    // Close button
    closeButton.position = CGPoint(x: modalBackground.frame.minX + 80, y: modalBackground.frame.maxY - 80)
    modal.addChild(closeButton)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
