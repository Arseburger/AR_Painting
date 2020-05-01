//
//  AlbumSelectionCell.swift
//  AR_Painting
//
//  Created by Александр Королёв on 25.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit
import Photos

class AlbumSelectionCell: UITableViewCell {
  
  private var userAlbums: PHFetchResult<PHAssetCollection>?
  private var userFavorites: PHFetchResult<PHAssetCollection>?
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.frame = self.frame
    collectionView.isScrollEnabled = true
//    self.fetchCollections()
  }
  
}

extension AlbumSelectionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 100
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionCell", for: indexPath) as! PhotoCollectionCell
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 118.0, height: 118.0)
  }
  
}

extension AlbumSelectionCell {
  
  func fetchCollections() {
    if let albums = PHCollectionList.fetchTopLevelUserCollections(with: nil) as? PHFetchResult<PHAssetCollection> {
      userAlbums = albums
    }
    
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    
    let assets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: (userAlbums?.firstObject)!, options: options)
    print(assets.count)

    
  }
  
}
