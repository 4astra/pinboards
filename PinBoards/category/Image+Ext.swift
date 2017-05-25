//
//  Image+Ext.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import UIKit

extension UIImage {
  
  var decompressedImage: UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    draw(at: CGPoint.zero)
    let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return decompressedImage!
  }
  
}
