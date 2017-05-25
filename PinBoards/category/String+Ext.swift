//
//  String+Ext.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation

extension String {
  static func md5(string: String) -> Data {
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes {digestBytes in
      messageData.withUnsafeBytes {messageBytes in
        CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
      }
    }
    
    return digestData
  }
  
  static func md5(from string: String) -> String {
    let md5Data = String.md5(string: string)
    return md5Data.map { String(format: "%02hhx", $0) }.joined()
  }
}
