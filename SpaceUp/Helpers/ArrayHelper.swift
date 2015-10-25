//
//  ArrayHelper.swift
//  SpaceUp
//
//  Created by David Chin on 2/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import Foundation

func << <T>(inout array: Array<T>, item: T) {
  array.append(item)
}

func >> <T>(inout array: Array<T>, item: T) {
  array.prepend(item)
}

func findIndex<T>(array: [T], callback: (T) -> Bool) -> Int? {
  for (index, elem): (Int, T) in array.enumerate() {
    if callback(elem) {
      return index
    }
  }
  
  return nil
}

func removeObject<T: Equatable>(object: T, inout fromArray array: [T]) -> Int? {
  if let index = array.indexOf(object) {
    array.removeAtIndex(index)
    
    return index
  }
  
  return nil
}

func removeObjectByReference<T: AnyObject>(object: T, inout fromArray array: [T]) -> Int? {
  if let index = findIndex(array, callback: { $0 === object }) {
    array.removeAtIndex(index)
    
    return index
  }
  
  return nil
}

func containsByReference<T: AnyObject>(sequence: [T], object: T) -> Bool {
  for item in sequence {
    if item === object {
      return true
    }
  }
  
  return false
}
