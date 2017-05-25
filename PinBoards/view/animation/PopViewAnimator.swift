//
//  PopViewAnimator.swift
//  PinBoards
//
//  Created by Brian Ha on 5/25/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation
import UIKit

class PopViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let duration = 0.5
  var isPresent = true
  var originFrame = CGRect.zero
  
  var dismissCompletion: (()->Void)?
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    
    let toViewCtr = transitionContext.view(forKey: .to)!
    
    let detailViewCtr = isPresent ? toViewCtr : transitionContext.view(forKey: .from)!
    
    let initialFrame = isPresent ? originFrame : detailViewCtr.frame
    let finalFrame = isPresent ? detailViewCtr.frame : originFrame
    
    let xScaleFactor = isPresent ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
    
    let yScaleFactor = isPresent ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
    
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    if isPresent {
      detailViewCtr.transform = scaleTransform
      detailViewCtr.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
      detailViewCtr.clipsToBounds = true
    }
    
    containerView.addSubview(toViewCtr)
    containerView.bringSubview(toFront: detailViewCtr)
    
    UIView.animate(withDuration: duration, delay:0.0, usingSpringWithDamping: 0.4,
                   initialSpringVelocity: 0.0,
                   animations: {
                    detailViewCtr.transform = self.isPresent ? CGAffineTransform.identity : scaleTransform
                    detailViewCtr.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
    },
                   completion:{_ in
                    if !self.isPresent {
                      self.dismissCompletion?()
                    }
                    transitionContext.completeTransition(true)
    }
    )
  }
}
