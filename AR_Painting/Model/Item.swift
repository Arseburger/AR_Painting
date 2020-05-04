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
    .asset: []
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
  
  func randomImage() -> UIImage? {
    var image = UIImage()
    let service = BaseService()
    //      self.showLoadingState()
    service.loadRandomPhoto(onComplete: { photos in
      DispatchQueue.global().async {
        let url = URL(string: (photos.urls.regular))
        let data = try? Data(contentsOf: url!)
        image = UIImage(data: data!)!
      }
    }) { error in print("mimo") }
    return image
  }
  
  func getImages() {
    let manager = PHImageManager.default()
    let assets = self.getUserImages()
    
    let assetsCount = assets.count
    
    for i in 0 ..< (assetsCount > 9 ? 10 : assetsCount) {
      let tenth = assetsCount > 9 ? assetsCount / 10 : 1
      let firstIndex = i * tenth
      let lastIndex = firstIndex + tenth + assetsCount % tenth
      autoreleasepool {
        for j in firstIndex ..< lastIndex {
          let asset = assets.object(at: j)
          manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: nil) { (assetImage , _) in
            self.data[.asset]?.append(assetImage)
          }
        }
      }
    }
  }
  
}




