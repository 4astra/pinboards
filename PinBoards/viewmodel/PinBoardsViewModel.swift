//
//  PinBoardsViewModel.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation

protocol PinBoardsProtocol {
  var pins: [Pin]? { get }
  var pinsGetCompleted: (()->Void)? { get }
  var pinsGetFailed: (()->Void)? { get }
  var pinsRefreshContent: (()->Void)? { get }
}

class PinBoardsViewModel: PinBoardsProtocol {
  var pins: [Pin]? = [Pin]()
  var pinsGetCompleted: (() -> Void)?
  var pinsGetFailed: (() -> Void)?
  var pinsRefreshContent: (() -> Void)?
  
  func pinboards() {
    PinBoardsBizCtr.pins { [weak self] (result) in
      DispatchQueue.main.async {
        guard let strong = self else {
          return
        }
        switch result {
        case .success(let data):
          strong.pins?.append(contentsOf: data!)
          strong.pinsGetCompleted?()
          break
        case .failure(_):
          strong.pinsGetFailed?()
          break
        }
      }
    }
  }
  
  func loadMore() {
    pinboards()
  }
  
  func refreshPinBoards() {
    self.pins?.removeAll()
    self.pinsRefreshContent?()
    pinboards()
  }
  
}
