//
//  PhotoModel.swift
//  AR_Painting
//
//  Created by Александр Королёв on 01.05.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import Foundation

struct PhotoModel: Codable {
  let id: String
  var width: Int
  var height: Int
  let urls : PhotoURLs
}

struct PhotoURLs: Codable {
  let full: String
  let regular: String
  let small: String
}
