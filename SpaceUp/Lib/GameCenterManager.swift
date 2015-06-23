//
//  GameCenterManager.swift
//  SpaceUp
//
//  Created by David Chin on 6/06/2015.
//  Copyright (c) 2015 David Chin. All rights reserved.
//

import GameKit

class GameCenterManager: NSObject {
  // MARK: - Vars
  var isAuthenticated = false
  var leaderboardIdentifier: String?
  
  weak var delegate: GameCenterManagerDelegate?
  
  // MARK: - Computed vars
  var localPlayer: GKLocalPlayer? {
    return GKLocalPlayer.localPlayer()
  }
  
  // MARK: - GameCenter
  func authenticateLocalPlayer() {
    localPlayer?.authenticateHandler = { [weak self] (viewController, error) -> Void in
      if let delegate = self?.delegate, localPlayer = self?.localPlayer {
        if let viewController = viewController {
          delegate.gameCenterManager?(self!, didProvideViewController: viewController)
        } else {
          self!.isAuthenticated = localPlayer.authenticated
          delegate.gameCenterManager?(self!, didAuthenticateLocalPlayer: localPlayer.authenticated)
        }
        
        if let error = error {
          delegate.gameCenterManager?(self!, didReceiveError: error)
        }
      }
    }
  }
  
  func promptLocalPlayerAuthentication() {
    if let url = NSURL(string: "gamecenter:") {
      UIApplication.sharedApplication().openURL(url)
    }
  }
  
  func loadDefaultLeaderboardIdentifier() {
    localPlayer?.loadDefaultLeaderboardIdentifierWithCompletionHandler { (leaderboardIdentifier, error) -> Void in
      self.leaderboardIdentifier = leaderboardIdentifier
      
      if let error = error {
        self.delegate?.gameCenterManager?(self, didReceiveError: error)
      } else {
        self.delegate?.gameCenterManager?(self, didLoadDefaultLeaderboardIdentifier: leaderboardIdentifier)
      }
    }
  }
  
  func reportScoreValue(scoreValue: Int64) {
    if leaderboardIdentifier == nil {
      let error = NSError.errorWithMessage("Leaderboard identifier is not available", code: 500)
      
      self.delegate?.gameCenterManager?(self, didReceiveError: error)
    } else {
      let score = GKScore(leaderboardIdentifier: leaderboardIdentifier, player: localPlayer)
      
      score.value = scoreValue
      
      GKScore.reportScores([score]) { error in
        if let error = error {
          self.delegate?.gameCenterManager?(self, didReceiveError: error)
        } else {
          self.delegate?.gameCenterManager?(self, didReportScore: score)
        }
      }
    }
  }
  
  func loadLeaderboardScore() {
    if let leaderboardIdentifier = leaderboardIdentifier, localPlayer = localPlayer {
      let leaderboard = GKLeaderboard(players: [localPlayer])
      
      leaderboard.identifier = leaderboardIdentifier
      
      leaderboard.loadScoresWithCompletionHandler { (scores, error) in
        if let error = error {
          self.delegate?.gameCenterManager?(self, didReceiveError: error)
        } else if let localPlayerScore = leaderboard.localPlayerScore {
          self.delegate?.gameCenterManager?(self, didLoadLocalPlayerScore: localPlayerScore)
        }
      }
    }
  }
}
