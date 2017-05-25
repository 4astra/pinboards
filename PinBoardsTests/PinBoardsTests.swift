//
//  PinBoardsTests.swift
//  PinBoardsTests
//
//  Created by Brian Ha on 5/23/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import XCTest
@testable import PinBoards

class PinBoardsTests: XCTestCase {
  var jsonURL: URL!
  var viewModel: PinBoardsViewModel!
  
  override func setUp() {
    jsonURL = URL(string: API.baseUrl + API.content)!
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }
  
  func testDefaultNumberOfPinBoard() {
    let urlExpectation = expectation(description: "Wait for \(jsonURL) to load.")
    var pin: [Pin]?
    PinBoardsBizCtr.pins { (result) in
      urlExpectation.fulfill()
      switch result {
      case .success(let data):
        pin = data
        break
      case .failure(_):
        break
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssert(pin?.count == 10, "Default number pinboards is not correct")
  }
  
  func testCacheIsEmpty() {
    XCTAssert(ContentDownloader.shared.caches.count <= 0, "Cache is not empty")
  }
  
  func testNotEmptyPinBoards() {
    let urlExpectation = expectation(description: "Wait for \(jsonURL) to load.")
    var pin: [Pin]?
    PinBoardsBizCtr.pins { (result) in
      urlExpectation.fulfill()
      switch result {
      case .success(let data):
        pin = data
        break
      case .failure(_):
        break
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertNotNil(pin)
  }
  
  func testCacheIsNotEmpty() {
    let imageURL = URL(string: "https://images.unsplash.com/photo-1464550883968-cec281c19761")
    let imageURLExpect = expectation(description: "Wait for \(imageURL!) to download")
    ContentDownloader.shared.downloadContent(with: imageURL!) { (cache) in
      imageURLExpect.fulfill()
    }
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssert(ContentDownloader.shared.caches.count > 0, "Cache is empty")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
