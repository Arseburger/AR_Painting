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
  
  var isChecked: Bool = false
  
  override var isSelected: Bool {
    didSet {
      if !isChecked {
        self.starView.isHidden = false
      } else {
        self.starView.isHidden = true
      }
    }
  }
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var starView: UIImageView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func getImage(from asset: PHAsset) {
    var image = UIImage()
    PHImageManager().requestImage(for: asset, targetSize: self.imageView.frame.size, contentMode: .aspectFit, options: nil) { assetImage, _  in
      image = assetImage ?? UIImage(named: "NoImage")!
    }
    self.imageView.image = image
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageView.image = nil
    self.imageView.layer.borderColor = .none
    self.imageView.layer.borderWidth = 0
    self.imageView.layer.cornerRadius = 0
    self.starView.isHidden = isSelected ? false : true
  }
  
}
