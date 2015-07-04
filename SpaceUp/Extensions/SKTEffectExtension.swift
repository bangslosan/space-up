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

extension SKTAlphaEffect {
  class func alphaEffectWithNode(node: SKNode, duration: NSTimeInterval, startAlpha: CGFloat, endAlpha: CGFloat, timingFunction: ((CGFloat) -> CGFloat)?) -> SKTAlphaEffect {
    let effect = SKTAlphaEffect(node: node, duration: duration, startAlpha: startAlpha, endAlpha: endAlpha)
    
    effect.timingFunction = timingFunction
    
    return effect
  }
  
  class func alphaActionWithNode(node: SKNode, duration: NSTimeInterval, startAlpha: CGFloat, endAlpha: CGFloat, timingFunction: ((CGFloat) -> CGFloat)?) -> SKAction {
    let effect = SKTAlphaEffect.alphaEffectWithNode(node, duration: duration, startAlpha: startAlpha, endAlpha: endAlpha, timingFunction: timingFunction)
    
    return SKAction.actionWithEffect(effect)
  }
}

class SKTAlphaEffect: SKTEffect {
  var startAlpha: CGFloat
  var previousAlpha: CGFloat
  var delta: CGFloat
  
  init(node: SKNode, duration: NSTimeInterval, startAlpha: CGFloat, endAlpha: CGFloat) {
    previousAlpha = node.alpha
    self.startAlpha = startAlpha
    delta = endAlpha - startAlpha
    super.init(node: node, duration: duration)
  }
  
  override func update(t: CGFloat) {
    let newAlpha = startAlpha + delta * t
    let diff = newAlpha / previousAlpha

    previousAlpha = newAlpha
    node.alpha *= diff
  }
}
