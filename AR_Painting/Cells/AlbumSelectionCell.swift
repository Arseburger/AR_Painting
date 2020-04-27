//
//  AlbumSelectionCell.swift
//  AR_Painting
//
//  Created by Александр Королёв on 25.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class AlbumSelectionCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
}

extension AlbumSelectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionCell", for: indexPath) as! PhotoCollectionCell
    return cell
  }
  
  
}
