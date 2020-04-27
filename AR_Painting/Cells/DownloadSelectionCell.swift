//
//  DownloadSelectionCell.swift
//  AR_Painting
//
//  Created by Александр Королёв on 27.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class DownloadSelectionCell: UITableViewCell {

  @IBOutlet weak var button: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    button.layer.cornerRadius = 15
    button.layer.borderWidth = 0.5
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.setBackgroundImage(UIImage(named: "UnsplashLogo"), for: .normal)
    button.setBackgroundImage(UIImage(named: "UnsplashLogo"), for: .selected)
    button.setBackgroundImage(UIImage(named: "UnsplashLogo"), for: .highlighted)
    button.setBackgroundImage(UIImage(named: "UnsplashLogo"), for: .focused)
  }

  
  
}
