//
//  PhotoCollectionCell.swift
//  AR_Painting
//
//  Created by Александр Королёв on 27.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let randomColor = UIColor(red: CGFloat.random(in: 0 ... 1), green: CGFloat.random(in: 0 ... 1), blue: CGFloat.random(in: 0 ... 1), alpha: 1.0)
    self.imageView.backgroundColor = randomColor
  }
  
  
}
