//
//  DetailPinViewCtr.swift
//  PinBoards
//
//  Created by Brian Ha on 5/25/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import UIKit

class DetailPinViewCtr: UIViewController, UIViewControllerTransitioningDelegate {
  
  @IBOutlet weak var ibClose: UIButton!
  @IBOutlet weak var ibBackground: UIImageView!
  var imageURL: URL!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard imageURL != nil else {
      return
    }
    
    ContentDownloader.shared.downloadContent(with: imageURL) { [weak self] (cache) in
      guard let strong = self else {
        return
      }
      if cache != nil {
        strong.ibBackground.image = UIImage(data: cache!.data!)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func close(_ sender: Any) {
    ibClose.isHidden = true
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
}
