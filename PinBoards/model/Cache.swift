//
//  Cache.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation

struct Cache {
  
  var name: String?
  var data: Data?
  var createdDate: Date?
  var recentCount = 0
  
}

extension Cache: Comparable {
  /// Returns a Boolean value indicating whether the value of the first
  /// argument is less than that of the second argument.
  ///
  /// This function is the only requirement of the `Comparable` protocol. The
  /// remainder of the relational operator functions are implemented by the
  /// standard library for any type that conforms to `Comparable`.
  ///
  /// - Parameters:
  ///   - lhs: A value to compare.
  ///   - rhs: Another value to compare.
  static func <(lhs: Cache, rhs: Cache) -> Bool {
    return lhs.recentCount < rhs.recentCount
  }
  
  /// Returns a Boolean value indicating whether the value of the first
  /// argument is equal that of the second argument.
  ///
  /// This function is the only requirement of the `Comparable` protocol. The
  /// remainder of the relational operator functions are implemented by the
  /// standard library for any type that conforms to `Comparable`.
  ///
  /// - Parameters:
  ///   - lhs: A value to compare.
  ///   - rhs: Another value to compare.
  static func ==(lhs: Cache, rhs: Cache) -> Bool {
    return lhs.recentCount == rhs.recentCount
  }
}
