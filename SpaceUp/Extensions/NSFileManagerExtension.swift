//
//  NSFileManagerExtension.swift
//  SpaceUp
//
//  Created by David Chin on 17/03/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit

extension NSFileManager {
  func URLForDirectory(directory: NSSearchPathDirectory, withPathComponent pathComponent: String, isDirectory: Bool = false) -> NSURL {
    if let documentURL = URLsForDirectory(directory, inDomains: .UserDomainMask).last {
      return documentURL.URLByAppendingPathComponent(pathComponent)
    }
    
    return NSURL()
  }
  
  func URLForPrivateDocumentsDirectory() -> NSURL {
    let url = URLForDirectory(.LibraryDirectory, withPathComponent: "Private Documents", isDirectory: true)
    var error: NSError?
    
    do {
      // Create directory if it doesn't exist
      try createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
    } catch let error1 as NSError {
      error = error1
    }
    
    if error != nil {
      fatalError("Failed to create Private Documents directory in Library Directory")
    }
    
    return url
  }
}
