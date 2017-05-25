//
//  PinPhotoCell.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import UIKit

class PinPhotoCell: UICollectionViewCell {
  @IBOutlet  weak var imageView: UIImageView!
  
  func config(with info: Pin) {
    ContentDownloader.shared.downloadContent(with: info.regularURL!) { (image) in
      guard image?.data != nil else {
        return
      }
      self.imageView.image = UIImage(data: image!.data!)
    }
  }
}
