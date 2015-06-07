//
//  NSErrorExtension.swift
//  SpaceUp
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import Foundation

extension NSError {
  public class func errorWithMessage(message: String, code: Int) -> NSError {
    var userInfo = [NSObject: AnyObject]()
    
    userInfo[NSLocalizedDescriptionKey] = message
    
    return NSError(domain: MainBundleIdentifier, code: code, userInfo: userInfo)
  }
}
