//
//  DataSource.swift
//  AR_Painting
//
//  Created by Александр Королёв on 02.05.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class DataSource: NSObject, UICollectionViewDataSource {
  let items = Item.shared
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return items.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let category = items.sections[section]
    let item = self.items.data[category]
    return item?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.reuseIdentifier, for: indexPath) as? PhotoCollectionCell else {
      fatalError()
    }
    
    if indexPath.section == 0 && indexPath.item == 0 {
      cell.layer.cornerRadius = cell.frame.width * 0.5
      cell.layer.borderColor = UIColor.lightGray.cgColor
      cell.layer.borderWidth = 0.5
    }
    
    let category = items.sections[indexPath.section]
    let image = self.items.data[category]?[indexPath.item] ?? UIImage(named: "NoImage")
    
    cell.imageView.image = image
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let itemHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ItemHeader.reuseIdentifier, for: indexPath) as? ItemHeader else { fatalError() }
    
    let category = items.sections[indexPath.section]
    itemHeader.sectionTitle.text = category.rawValue
    itemHeader.sectionTitle.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
    itemHeader.sectionTitle.textColor = CustomColors.pink
    itemHeader.layer.backgroundColor = CustomColors.blue.cgColor
    
    return itemHeader
  }
  
  
  
}
