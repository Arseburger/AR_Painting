//
//  ItemHeader.swift
//  AR_Painting
//
//  Created by Александр Королёв on 02.05.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class ItemHeader: UICollectionReusableView {
  static let reuseIdentifier = String(describing: ItemHeader.self)
  
  @IBOutlet weak var sectionTitle: UILabel!
  
//  override func awakeFromNib() {
//    super.awakeFromNib()
//  }
}
