//
//  PinBoardsBizCtr.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation

final class PinBoardsBizCtr {
  static let background = DispatchQueue(label: "run.hockey.hoatha", qos: .background,
                                        attributes: .concurrent,
                                        autoreleaseFrequency: .inherit, target: nil)
 
  // MARK: - Pinboards
  
  static func pins(handler resultHandler: @escaping (Result<[Pin]?>) -> Void) {
    background.async {
      NetworkManager.GET(from: API.content, response: { dict in
        pinsResponse(dict: dict, resultHandler: resultHandler)
      })
    }
  }
  
  static func pinsResponse(dict: [String: Any]?, resultHandler:@escaping (Result<[Pin]?>) -> Void) {
    guard dict != nil else {
      resultHandler(Result.failure(nil))
      return
    }
    var posts = [Pin]()
    if let data = dict!["data"] as? [Any] {
      for item in data {
        let post = try? Pin(json: item as! [String : Any])
        if post != nil {
          posts.append(post!)
        }
      }
    }
    resultHandler(Result.success(posts))
  }
}
