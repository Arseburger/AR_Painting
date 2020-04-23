//
//  TitleCell.swift
//  AR_Painting
//
//  Created by Александр Королёв on 23.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none

    titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    
  }
  
}
