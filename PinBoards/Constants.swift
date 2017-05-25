//
//  Constants.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation

// MARK: - Generate a T type

enum Result<T> {
  case success(T)
  case failure(T)
}

// MARK: - Error Handling

enum SerializationError: Error {
  case missing(String)
  case invalid(String)
}

// MARK: - API information

struct API {
  // Base URL
  static let baseUrl               = "http://pastebin.com/"
  
  // Get all post
  static let content                  = "raw/wgkJgazE"
}

struct TitleName {
  static let refresh                  = "Refresh"
}
