//
//  CollectionViewDelegate.swift
//  AR_Painting
//
//  Created by Александр Королёв on 03.05.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class CollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
  
  let numberOfItemsPerRow: CGFloat
  let interItemSpacing: CGFloat
  
  init(numberOfItemsPerRow: CGFloat, interItemSpacing: CGFloat) {
    self.numberOfItemsPerRow = numberOfItemsPerRow
    self.interItemSpacing = interItemSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxWidth = UIScreen.main.bounds.width
    let scaling = interItemSpacing * numberOfItemsPerRow
    
    let itemSide = (maxWidth - scaling) / numberOfItemsPerRow
    return CGSize(width: itemSide, height: itemSide)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return interItemSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: interItemSpacing, left: interItemSpacing, bottom: interItemSpacing, right: interItemSpacing)
  }
  
  
}
