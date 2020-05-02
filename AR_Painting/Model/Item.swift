//
//  Item.swift
//  AR_Painting
//
//  Created by Александр Королёв on 02.05.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class Item {
  
  enum Category: String, CaseIterable {
    case unsplash = "Загрузить случайное фото"
    case asset = "Выбрать фото из галереи"
  }
  
  static let shared = Item()
  
  let sections = Category.allCases
  
  var data: [Category: [UIImage?]] = [
    .unsplash: [UIImage(named: "UnsplashLogo")!],
    .asset: [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  ]
  
  private init() { }
  
  func item(at indexPath: IndexPath) -> UIImage? {
    let category = sections[indexPath.section]
    return data[category]?[indexPath.item]
  }
  
  
}
