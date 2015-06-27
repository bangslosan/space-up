//
//  UIColorExtension.swift
//  SpaceUp
//
//  Created by David Chin on 1/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(hexString: String, alpha: CGFloat = 1) {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var hexValue: CUnsignedLongLong = 0
    
    let scanner = NSScanner(string: hexString)
    
    scanner.scanLocation = 1

    if scanner.scanHexLongLong(&hexValue) {
      red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255
      green = CGFloat((hexValue & 0x00FF00) >> 8) / 255
      blue  = CGFloat(hexValue & 0x0000FF) / 255
    }

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}