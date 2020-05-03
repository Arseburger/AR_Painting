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
  
  var data: [Category: [UIImage?]] = [
    .unsplash: [UIImage(named: "UnsplashLogo")],
    .asset: [nil]
  ]
  
  private init() { }
  
  func item(at indexPath: IndexPath) -> UIImage? {
    let category = sections[indexPath.section]
    return data[category]?[indexPath.item]
  }
  
  func getUserImages() -> PHFetchResult<PHAsset> {
    let options = PHFetchOptions()
    options.predicate = NSPredicate(format: "mediaType = %i", PHAssetMediaType.image.rawValue)
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    let assets = PHAsset.fetchAssets(with: options)
    print(assets.count)
    return assets
  }
  
  func getImages(with size: CGSize) {
    let manager = PHImageManager.default()
    let assets = self.getUserImages()
    for i in 0 ..< assets.count {
      let asset = assets.object(at: i)
      manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { (image , _) in
        self.data[.asset]?.append(image)
      }
      
    }
  }
}
  
  

