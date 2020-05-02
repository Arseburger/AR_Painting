//
//  PhotoCollectionCell.swift
//  AR_Painting
//
//  Created by Александр Королёв on 27.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionCell: UICollectionViewCell {
  
  static let reuseIdentifier = String(describing: PhotoCollectionCell.self)
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func getImage(from asset: PHAsset) -> UIImage? {
    var image = UIImage()
    PHImageManager().requestImage(for: asset, targetSize: self.frame.size, contentMode: .aspectFill, options: nil) { assetIamge, info  in
      image = assetIamge ?? UIImage(named: "NoImage")!
    }
    return image
  }
  
}
