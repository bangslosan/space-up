//
//  ButtonDelegate.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import Foundation

@objc protocol ButtonDelegate: class {
  optional func touchBeganForButton(button: ButtonNode) -> Void
  optional func touchEndedForButton(button: ButtonNode) -> Void
}
