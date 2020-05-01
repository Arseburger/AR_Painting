//
//  DownloadSelectionCell.swift
//  AR_Painting
//
//  Created by Александр Королёв on 27.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class DownloadSelectionCell: UITableViewCell {
  
  var photo: UIImage?
  
  @IBOutlet weak var button: UIButton!
  @IBAction func getRandomPhotoFromUnsplash(_ sender: Any) {
    
    let service = BaseService()
    service.loadRandomPhoto(onComplete: { photos in
      DispatchQueue.global().async {
        let url = URL(string: (photos.urls.regular))
        let data = try? Data(contentsOf: url!)
        self.photo = UIImage(data: data!)!
        print(self.photo)
      }
    })
    { error in print("mimo") }
    
    
    
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    button.layer.cornerRadius = 15
    button.layer.borderWidth = 0.5
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.setBackgroundImage(UIImage(named: "UnsplashLogo"), for: .normal)
    button.setBackgroundImage(UIImage(named: "UnsplashLogoHighlited"), for: .highlighted)
  }
  
  func showLoading() {
    
  }
  
//  func showComplete() -> UIView{
//    let complete = UIView(frame: <#T##CGRect#>)
//    return complete
//  }
  
  
}
