//
//  LoadingIndicatorView.swift
//  SpaceUp
//
//  Created by David Chin on 27/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIView {
  static let sharedView = LoadingIndicatorView()

  private let loadingView = UIView()
  private let indicatorContainerView = UIView()
  private let indicatorView = UIActivityIndicatorView()
  
  var ignoreInteractionEvents: Bool = false {
    didSet {
      if ignoreInteractionEvents {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
      } else {
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
      }
    }
  }
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Configure
    alpha = 0
    
    // Subviews
    indicatorContainerView.addSubview(indicatorView)
    addSubview(indicatorContainerView)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Visibility
  func showInView(view: UIView) {
    frame = view.frame
    center = view.center
    backgroundColor = UIColor.clearColor()
    ignoreInteractionEvents = true
    
    indicatorContainerView.frame = CGRectMake(0, 0, 80, 80)
    indicatorContainerView.center = view.center
    indicatorContainerView.backgroundColor = UIColor(white: 0, alpha: 0.7)
    indicatorContainerView.clipsToBounds = true
    indicatorContainerView.layer.cornerRadius = 10
    
    indicatorView.frame = CGRectMake(0, 0, 40, 40)
    indicatorView.activityIndicatorViewStyle = .WhiteLarge
    indicatorView.center = CGPointMake(indicatorContainerView.bounds.width / 2, indicatorContainerView.bounds.height / 2)
    
    // Add
    view.addSubview(self)
    
    // Appear
    indicatorView.startAnimating()
    
    UIView.animateWithDuration(0.5) {
      self.alpha = 1
    }
  }
  
  func dismiss() {
    ignoreInteractionEvents = false
    
    UIView.animateWithDuration(0.5, animations: {
      self.alpha = 0
    }) { _ in
      self.indicatorView.stopAnimating()
      self.removeFromSuperview()
    }
  }
}
