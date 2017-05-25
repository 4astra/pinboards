//
//  Pin.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation
import UIKit


struct Pin {
  var id: String?
  var width: Int = 0
  var height: Int = 0
  var comment: String
  var regularURL: URL?
}

extension Pin {
  
  init(json: [String: Any]) throws {
    
    guard let id = json["id"] as? String else {
      throw SerializationError.missing("id")
    }
    guard let width = json["width"] as? Int else {
      throw SerializationError.missing("width")
    }
    guard let height = json["height"] as? Int else {
      throw SerializationError.missing("height")
    }
    guard let urls = json["urls"] as? [String: Any] else {
      throw SerializationError.missing("urls")
    }
    guard let regular = urls["regular"] as? String else {
      throw SerializationError.missing("regular")
    }
    guard URL.init(string: regular) != nil else {
      throw SerializationError.invalid("regular")
    }
    self.id = id
    self.width = width
    self.height = height
    self.regularURL = URL(string: regular)
    self.comment = ""
  }
}

extension Pin: CustomStringConvertible {
  var description: String {
    return "[id:\(String(describing: self.id)))]"
  }
}
