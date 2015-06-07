//
//  InterstitialAdView.swift
//  SpaceUp
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit
import iAd

class InterstitialAdView: UIView {
  let closeButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    closeButton.frame = CGRect(x: 20, y: 20, width: 30, height: 30)
    closeButton.setTitle("x", forState: .Normal)
    closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    closeButton.backgroundColor = UIColor.whiteColor()
    closeButton.layer.cornerRadius = 15
    closeButton.layer.borderColor = UIColor.blackColor().CGColor
    closeButton.layer.borderWidth = 1
    closeButton.layer.zPosition = 1000
    
    addSubview(closeButton)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Presentation
  func presentInterstitialAd(interstitialAd: ADInterstitialAd) {
    interstitialAd.presentInView(self)

    bringSubviewToFront(closeButton)
  }
}
