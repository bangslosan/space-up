//
//  SKTEffectExtension.swift
//  SpaceUp
//
//  Created by David Chin on 18/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import SpriteKit

extension SKTScaleEffect {
  class func scaleEffectWithNode(node: SKNode, duration: NSTimeInterval, startScale: CGPoint, endScale: CGPoint, timingFunction: ((CGFloat) -> CGFloat)?) -> SKTScaleEffect {
    let effect = SKTScaleEffect(node: node, duration: duration, startScale: startScale, endScale: endScale)
    
    effect.timingFunction = timingFunction
    
    return effect
  }
  
  class func scaleActionWithNode(node: SKNode, duration: NSTimeInterval, startScale: CGPoint, endScale: CGPoint, timingFunction: ((CGFloat) -> CGFloat)?) -> SKAction {
    let effect = SKTScaleEffect.scaleEffectWithNode(node, duration: duration, startScale: startScale, endScale: endScale, timingFunction: timingFunction)
    
    return SKAction.actionWithEffect(effect)
  }
}
