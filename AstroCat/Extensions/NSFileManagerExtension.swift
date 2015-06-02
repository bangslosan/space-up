//
//  NSFileManagerExtension.swift
//  AstroCat
//
//  Created by David Chin on 17/03/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit

extension NSFileManager {
  func URLForDirectory(directory: NSSearchPathDirectory, withPathComponent pathComponent: String, isDirectory: Bool = false) -> NSURL {
    let documentURL = URLsForDirectory(directory, inDomains: .UserDomainMask).last as! NSURL
    
    return documentURL.URLByAppendingPathComponent(pathComponent)
  }
  
  func URLForPrivateDocumentsDirectory() -> NSURL {
    let url = URLForDirectory(.LibraryDirectory, withPathComponent: "Private Documents", isDirectory: true)
    var error: NSError?
    
    // Create directory if it doesn't exist
    createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil, error: &error)
    
    if error != nil {
      fatalError("Failed to create Private Documents directory in Library Directory")
    }
    
    return url
  }
}
