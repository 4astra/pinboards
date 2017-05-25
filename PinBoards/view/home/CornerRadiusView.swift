//
//  CornerRadiusView.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import UIKit

@IBDesignable
class CornerRadiusView: UIView {
  
  @IBInspectable var cornerRadius: CGFloat = 0.0 {
    didSet {
      layer.borderColor = UIColor.groupTableViewBackground.cgColor
      layer.borderWidth = 0.5
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
}
