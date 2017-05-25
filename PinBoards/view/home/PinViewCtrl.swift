//
//  PinViewCtrl.swift
//  PinBoards
//
//  Created by Brian Ha on 5/25/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import UIKit

class PinViewCtrl: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var refreshControl: UIRefreshControl!
  var isRefesh = false
  
  var transition: PopViewAnimator! {
    didSet {
      transition.dismissCompletion  = { [weak self] transition in
        guard let strong = self  else {
          return
        }
        strong.selectedImage?.isHidden = false
      }
    }
  }
  var selectedImage: UIImageView?
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  var viewModel: PinBoardsViewModel! {
    didSet {
      viewModel.pinsGetCompleted = { [weak self] viewModel in
        guard let strong = self else {
          return
        }
        strong.isRefesh = false
        strong.refreshControl.endRefreshing()
        strong.collectionView?.reloadData()
      }
    }
  }
  
  func setupLayout() {
    title = "Pin Boards"
    
    // Set Pin Layout delegate
    
    refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.groupTableViewBackground
    refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    self.refreshControl.attributedTitle = NSAttributedString(string: TitleName.refresh)
    
    collectionView?.addSubview(refreshControl)
    collectionView?.alwaysBounceVertical = true
    
  }
  
  func refresh(sender: AnyObject) {
    refreshControl.beginRefreshing()
    isRefesh = true
    viewModel.refreshPinBoards()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLayout()
    
    viewModel = PinBoardsViewModel()
    viewModel.pinboards()
    transition = PopViewAnimator()
    
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
  }
}

// MARK: - UIScrollViewDelegate

extension PinViewCtrl {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard viewModel != nil && !isRefesh else {
      return
    }
    
    if UIView.isScrollToBottom(scrollView: scrollView) {
      viewModel.loadMore()
    }
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      guard viewModel != nil && !isRefesh else {
        return
      }
      
      if UIView.isScrollToBottom(scrollView: scrollView) {
        viewModel.loadMore()
      }
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PinViewCtrl: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.size.width / 2.0 - 15 , height: collectionView.bounds.size.width / 2.0)
  }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension PinViewCtrl: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard viewModel != nil else {
      return 0
    }
    return viewModel.pins!.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinPhotoCell", for: indexPath) as! PinPhotoCell
    cell.config(with: viewModel.pins![indexPath.row])
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! PinPhotoCell
    selectedImage = cell.imageView
    // detail view controller
    let detail = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailPinViewCtr.self)) as! DetailPinViewCtr
    detail.transitioningDelegate = self
    detail.imageURL = viewModel.pins![indexPath.row].regularURL
    
    present(detail, animated: true, completion: nil)
  }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PinViewCtrl: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if selectedImage != nil {
      transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)
    }
    transition.isPresent = true
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.isPresent = false
    return transition
  }
}

