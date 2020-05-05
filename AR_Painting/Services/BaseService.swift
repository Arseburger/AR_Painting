//
//  BaseService.swift
//  AR_Painting
//
//  Created by Александр Королёв on 01.05.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import Foundation

enum ServerError: Error {
  case noDataProvided
  case decodingFailed
}

class BaseService {
  
  func loadRandomPhoto(onComplete: @escaping (PhotoModel) -> Void, onError: @escaping (Error) -> Void) {
    let requestURL = NetworkConstants.baseURL + "/photos/random/?client_id=" + NetworkConstants.accessKey
    let url = URL(string: requestURL)!
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        onError(error)
        return
      }
      
      guard let data = data else {
        onError(ServerError.noDataProvided)
        return
      }
      
      guard let photos = try? JSONDecoder().decode(PhotoModel.self, from: data) else {
        onError(ServerError.decodingFailed)
        print("couldn't decode")
        return
      }
      
      onComplete(photos)
      
    }
    task.resume()
  }
  
}
