//
//  UIColorExtension.swift
//  SpaceUp
//
//  Created by David Chin on 1/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(hexString: String) {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 1
    var hexValue: CUnsignedLongLong = 0
    
    let scanner = NSScanner(string: hexString)
    let hexLength = count(hexString) - 1
    
    scanner.scanLocation = 1

    if scanner.scanHexLongLong(&hexValue) {
      switch hexLength {
      case 3:
        red   = CGFloat((hexValue & 0xF00) >> 8) / 15
        green = CGFloat((hexValue & 0x0F0) >> 4) / 15
        blue  = CGFloat(hexValue & 0x00F) / 15

      case 4:
        red   = CGFloat((hexValue & 0xF000) >> 12) / 15
        green = CGFloat((hexValue & 0x0F00) >> 8) / 15
        blue  = CGFloat((hexValue & 0x00F0) >> 4) / 15
        alpha = CGFloat(hexValue & 0x000F) / 15

      case 6:
        red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255
        green = CGFloat((hexValue & 0x00FF00) >> 8) / 255
        blue  = CGFloat(hexValue & 0x0000FF) / 255

      case 8:
        red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255
        green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255
        blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255
        alpha = CGFloat(hexValue & 0x000000FF) / 255

      default:
        break
      }
    }

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}