//
//  SKNodeExtension.swift
//  AstroCat
//
//  Created by David Chin on 31/01/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

extension SKNode {
  func childNodesWithName(name: String) -> [SKNode] {
    var nodes = [SKNode]()

    enumerateChildNodesWithName(name) { (node, _) in
      if node.name == name {
        nodes.append(node)
      }
    }
    
    return nodes
  }
  
  func addChild(child: SKNode, removeFromParentIfNeeded: Bool) {
    if removeFromParentIfNeeded && !child.inParentHierarchy(self) {
      child.removeFromParent()
      addChild(child)
    } else {
      addChild(child)
    }
  }
  
  func addChildIfNeeded(child: SKNode) {
    addChild(child, unlessInParentHierarchy: self)
  }
  
  func addChild(child: SKNode, unlessInParentHierarchy parent: SKNode) {
    if !child.inParentHierarchy(parent) && child.parent == nil {
      addChild(child)
    }
  }
  
  func addToParent(parent: SKNode) {
    parent.addChild(self)
  }
  
  func isNode(node: SKNode, containedInFrame frame: CGRect) -> Bool {
    if let nodeParent = node.parent {
      let position = convertPoint(node.position, fromNode: nodeParent)
      
      return frame.contains(position)
    }
    
    return false
  }
  
  func isOffscreen(offset: CGPoint = CGPointZero, axis: AxisType = .Both) -> Bool {
    if let scene = scene where inParentHierarchy(scene) {
      var screenFrame = scene.screenFrame
      let frame = scene.convertFrame(self.frame, fromNode: parent!)

      screenFrame.offset(dx: offset.x, dy: offset.y)

      switch axis {
      case .X:
        return frame.maxX < screenFrame.minX || frame.minX > screenFrame.maxX
        
      case .Y:
        return frame.maxY < screenFrame.minY || frame.minY > screenFrame.maxY
        
      default:
        let adjustScreenFrame = CGRect(x: screenFrame.origin.x, y: screenFrame.origin.y - offset.y,
                                       width: screenFrame.width, height: screenFrame.height + offset.y)
        
        return !scene.isNode(self, containedInFrame: adjustScreenFrame)
      }
    }
    
    return true
  }
  
  func convertFrame(frame: CGRect, fromNode node: SKNode) -> CGRect {
    let point = convertPoint(frame.origin, fromNode: node)
    
    return CGRect(origin: point, size: frame.size)
  }
  
  func convertFrame(frame: CGRect, toNode node: SKNode) -> CGRect {
    let point = convertPoint(frame.origin, toNode: node)
    
    return CGRect(origin: point, size: frame.size)
  }
  
  func hasActionForKey(key: String) -> Bool {
    return actionForKey(key) != nil
  }
  
  func runAction(action: SKAction, withKey key: String? = nil, when condition: Bool) {
    if condition {
      key == nil ? runAction(action) : runAction(action, withKey: key)
    }
  }
}
