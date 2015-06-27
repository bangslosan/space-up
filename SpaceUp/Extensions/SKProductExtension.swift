//
//  SKProductExtension.swift
//  SpaceUp
//
//  Created by David Chin on 27/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit
import StoreKit

extension SKProduct {
  var formattedPrice: String {
    let numberFormatter = NSNumberFormatter()
    
    numberFormatter.formatterBehavior = .Behavior10_4
    numberFormatter.numberStyle = .CurrencyStyle
    numberFormatter.locale = priceLocale
    
    return numberFormatter.stringFromNumber(price)!
  }
}
