//
//  Array+Ext.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation

extension Array {
  
  public func mapWithIndex<T> (f: (Int, Element) -> T) -> [T] {
    return zip((self.startIndex ..< self.endIndex), self).map(f)
  }
}
