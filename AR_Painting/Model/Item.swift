//
//  Item.swift
//  AR_Painting
//
//  Created by Александр Королёв on 02.05.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit
import Photos

class Item {
  
  enum Category: String, CaseIterable {
    case unsplash = "Загрузить случайное фото"
    case asset = "Выбрать фото из галереи"
  }
  
  static let shared = Item()
  
  let sections = Category.allCases
  
  var data: [Category: PHFetchResult<PHAsset>?] = [ .unsplash: nil, .asset: nil ]
  
  private init() { }
  
  func item(at indexPath: IndexPath) -> (Category, PHAsset?)? {
    let category = sections[indexPath.section]
    return (category, data[category]??.object(at: indexPath.item))
  }
  
  func getUserImages() {
    let options = PHFetchOptions()
    options.predicate = NSPredicate(format: "mediaType = %i", PHAssetMediaType.image.rawValue)
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    let assets = PHAsset.fetchAssets(with: options)
    data[.asset] = assets
  }
  
}




