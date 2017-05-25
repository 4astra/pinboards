//
//  NetworkManager.swift
//  PinBoards
//
//  Created by Brian Ha on 5/24/17.
//  Copyright © 2017 HocKey Run. All rights reserved.
//

import Foundation

final class NetworkManager {
  
  static func GET(from endpoint: String, response: @escaping (_ dict: [String: Any]?) -> Void) {
    
    let url = URL(string: API.baseUrl + endpoint)
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
      guard error == nil else {
        response(nil)
        return
      }
      guard let newData = data else {
        response(nil)
        return
      }
      
      let json = try? JSONSerialization.jsonObject(with: newData, options: []) as? [Any]
      if json != nil {
        response(["data" : json! as Any])
      }
      else {
        response(nil)
      }
    }
    
    task.resume()
  }
  
  static func download(from url: URL?, response: @escaping (_ data: Data?) -> Void) {
    guard let newUrl = url else {
      response(nil)
      return
    }
    var urlRequest = URLRequest(url: newUrl)
    urlRequest.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlRes, error) in
      guard error == nil else {
        response(nil)
        return
      }
      response(data)
    }
    
    task.resume()
  }
  
}
