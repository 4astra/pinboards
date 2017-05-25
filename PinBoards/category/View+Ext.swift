//
//  View+Ext.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView

extension UIView {
  
  static func isScrollToBottom(scrollView: UIScrollView) -> Bool {
    let offset = scrollView.contentOffset
    let bound = scrollView.bounds
    let size = scrollView.contentSize
    let inset = scrollView.contentInset
    let y = offset.y + bound.size.height - inset.bottom
    if Int(y) >= Int(size.height) {
      return true
    }
    return false
  }
}
