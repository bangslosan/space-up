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
  let closeButton = UIButton(type: UIButtonType.Custom)

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    closeButton.frame = CGRect(x: 15, y: 15, width: 32, height: 32)
    closeButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 18)
    closeButton.titleLabel?.textAlignment = .Center
    closeButton.setTitle("\u{f00d}", forState: .Normal)
    closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    closeButton.backgroundColor = UIColor.blackColor()
    closeButton.layer.cornerRadius = 6
    closeButton.layer.zPosition = 1000
    
    addSubview(closeButton)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Presentation
  func presentInterstitialAd(interstitialAd: ADInterstitialAd) {
    interstitialAd.presentInView(self)

    bringSubviewToFront(closeButton)
  }
}
