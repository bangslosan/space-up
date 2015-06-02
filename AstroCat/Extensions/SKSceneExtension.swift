//
//  SKSceneExtension.swift
//  AstroCat
//
//  Created by David Chin on 8/02/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

extension SKScene {
  var screenFrame: CGRect {
    let screenBounds = UIScreen.mainScreen().bounds

    let width = screenBounds.width / aspectFillScale
    let height = screenBounds.height / aspectFillScale
    let x = (frame.width - width) / 2
    let y = (frame.height - height) / 2
  
    return CGRect(x: x, y: y, width: width, height: height)
  }
  
  var aspectFillScale: CGFloat {
    let screenBounds = UIScreen.mainScreen().bounds
    
    return max(screenBounds.width / frame.width, screenBounds.height / frame.height)
  }
  
  class func unarchiveFromSksFile(file: String) -> SKScene? {
    if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
      var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
      var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
      
      archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
      
      let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
      archiver.finishDecoding()
      
      return scene
    } else {
      return nil
    }
  }
  
  class func unarchiveWithFileName(fileName: String) -> SKScene? {
    let directoryURL = NSFileManager.defaultManager().URLForPrivateDocumentsDirectory()
    let fileURL = directoryURL.URLByAppendingPathComponent(fileName)
    
    if let file = fileURL.path {
      if let scene = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? SKScene {
        return scene
      }
    }
    
    return nil
  }
  
  class func removeArchiveWithFileName(fileName: String) -> Bool {
    let fileManager = NSFileManager.defaultManager()
    let directoryURL = fileManager.URLForPrivateDocumentsDirectory()
    let fileURL = directoryURL.URLByAppendingPathComponent(fileName)
    
    var error: NSError?
    let success = fileManager.removeItemAtURL(fileURL, error: &error)
    
    if error != nil {
      println(error)
    }
    
    return success
  }

  func archiveWithFileName(fileName: String) {
    let directoryURL = NSFileManager.defaultManager().URLForPrivateDocumentsDirectory()
    let fileURL = directoryURL.URLByAppendingPathComponent(fileName)
    
    // Encode
    let data = NSKeyedArchiver.archivedDataWithRootObject(self)
    
    data.writeToURL(fileURL, atomically: true)
  }
}
