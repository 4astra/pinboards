//
//  ContentDownloader.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation

protocol ContentProtocol {
  var maxCapacity: Double { get }
  var caches:[Cache] { get }
}

class ContentDownloader: ContentProtocol {
  static let backgroundQueue = DispatchQueue(label: "run.hockey.content", qos: .background,
                                             attributes: DispatchQueue.Attributes.concurrent,
                                             autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
  static let shared = ContentDownloader()
  private init() {}
  
  // content will be cached
  
  internal var caches: [Cache] = [Cache]()
  
  // maximium cache
  
  var maxCapacity: Double = 10.0 // Megabyte
  
  // find a item that seldom be used
  
  func infrequentItem() -> (Int, Cache?) {
    
    guard caches.count > 0 else {
      return (-1, nil) // -1: Not found index
    }
    let min = caches.min()
    let map = caches.mapWithIndex { (index, item) -> Int in
      if item.name == min!.name {
        return index
      }
      return -1
      }.filter { (index) -> Bool in
        index != -1
    }
    
    guard map.count > 0 else {
      return (-1, nil) // -1: Not found index
    }
    let index = map.first
    return (index!, caches[index!])
  }
  
  // calculator the current capacity
  
  func takeCapacity() -> Double {
    var sum: Double = 0.0
    for item in caches {
      sum =  sum + Double(item.data!.count)
    }
    return (sum / 1024.0 / 1024.0)
  }
  
  // delete item at index
  
  func delete(at index: Int) {
    if index > caches.count {
      return
    }
    caches.remove(at: index)
  }
  
  // add a item to caches
  
  func add(cache item: Cache) {
    // check the capacity of cache before add a item
    if self.takeCapacity() >= maxCapacity {
      let item = self.infrequentItem()
      
      print("Capacity is overload")
      print("Delete a item with hex name: \(String(describing: item.1?.name))")
      
      let index = item.0
      if index != -1 && index < caches.count {
        self.delete(at: item.0)
      }
    }
    
    caches.append(item)
  }
  
  // find a item with url
  func find(with url: String?) -> Cache? {
    
    guard url != nil else {
      return nil
    }
    
    let md5HexUrl = String.md5(from: url!)
    let map = caches.mapWithIndex { (index, item) -> Int in
      if item.name == md5HexUrl {
        return index
      }
      return -1
      }
      .filter { (index) -> Bool in
        index != -1
    }
    
    if let index = map.first {
      caches[index].recentCount = caches[index].recentCount + 1
      return caches[index]
    }
    
    return nil
  }
  
  // dowload image
  func downloadContent(with url: URL, completed: @escaping (Cache?) -> Void) {
    let local = find(with: url.path)
    
    guard local == nil else {
      print("get content from local")
      completed(local)
      return
    }
    
    ContentDownloader.backgroundQueue.async {
      print("get content from network")
      NetworkManager.download(from: url) { [weak self] (data) in
        DispatchQueue.main.async {
          guard let strong = self else {
            completed(nil)
            return
          }
          let cache = Cache(name: String.md5(from: url.path), data: data, createdDate: Date(), recentCount: 1)
          strong.add(cache: cache)
          completed(cache)
        }
      }
    }
  }
}
