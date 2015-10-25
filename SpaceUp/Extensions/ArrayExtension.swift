//
//  ArrayExtension.swift
//  SpaceUp
//
//  Created by David Chin on 9/03/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit

extension Array {
  func pick(index: Int) -> Element? {
    if 0 <= index && index < count {
      return self[index]
    } else {
      return nil
    }
  }
  
  func pick(subRange: Range<Int>) -> ArraySlice<Element>? {
    if count == 0 {
      return nil
    }
    
    let cappedRange = max(subRange.startIndex, 0)..<min(subRange.endIndex - subRange.startIndex, count)
    
    return self[cappedRange]
  }
  
  func sample() -> Element? {
    let index = Int(arc4random_uniform(UInt32(count)))

    return self.pick(index)
  }
  
  func find(callback: (Element) -> Bool) -> Element? {
    for item in self {
      if callback(item) {
        return item
      }
    }
    
    return nil
  }
  
  mutating func prepend(newElement: Element) {
    insert(newElement, atIndex: 0)
  }
}
