//
//  PaymentTransactionObserver
//  SpaceUp
//
//  Created by David Chin on 27/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import UIKit
import StoreKit

class PaymentTransactionObserver: NSObject, SKPaymentTransactionObserver {
  // MARK: - Transaction
  func completeTransaction(transaction: SKPaymentTransaction) {
    let queue = SKPaymentQueue.defaultQueue()
    
    updateUserDefaultsWithBoolValue(true, forKey: transaction.payment.productIdentifier)
    
    queue.finishTransaction(transaction)
    
    postNotificatonName(PaymentTransactionDidCompleteNotification, forTransaction: transaction)
  }
  
  func restoreTransaction(transaction: SKPaymentTransaction) {
    let queue = SKPaymentQueue.defaultQueue()
    
    updateUserDefaultsWithBoolValue(true, forKey: transaction.originalTransaction.payment.productIdentifier)
    
    queue.finishTransaction(transaction)

    postNotificatonName(PaymentTransactionDidRestoreNotification, forTransaction: transaction.originalTransaction)
  }
  
  func failedTransaction(transaction: SKPaymentTransaction) {
    let queue = SKPaymentQueue.defaultQueue()
    
    if let error = transaction.error where error.code != SKErrorPaymentCancelled {
      println("Transaction error: \(transaction.error.localizedDescription)")
    }
    
    queue.finishTransaction(transaction)
    
    postNotificatonName(PaymentTransactionDidFailNotification, forTransaction: transaction)
  }
  
  func provideContentForProductIdentifier(identifier: String) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    userDefaults.setBool(true, forKey: identifier)
    userDefaults.synchronize()
  }
  
  // MARK: - SKPaymentTransactionObserver
  func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
    if let transactions = transactions {
      for transaction in transactions {
        if let transaction = transaction as? SKPaymentTransaction {
          switch (transaction.transactionState) {
          case SKPaymentTransactionState.Purchased:
            completeTransaction(transaction)
            
          case SKPaymentTransactionState.Restored:
            restoreTransaction(transaction)
            
          case SKPaymentTransactionState.Failed:
            failedTransaction(transaction)
            
          default:
            break
          }
        }
      }
    }
  }
  
  func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
    postNotificatonName(PaymentTransactionDidRestoreAllNotification, forTransaction: nil)
  }
  
  // MARK: - Notification
  private func postNotificatonName(name: String, forTransaction transaction: SKPaymentTransaction?) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var userInfo = [NSObject: AnyObject]()
    
    if let transaction = transaction {
      userInfo["transaction"] = transaction
    }
    
    notificationCenter.postNotificationName(name, object: self, userInfo: userInfo)
  }
  
  // MARK: - UserDefaults
  private func updateUserDefaultsWithBoolValue(value: Bool, forKey key: String) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    userDefaults.setBool(value, forKey: key)
    userDefaults.synchronize()
  }
}
