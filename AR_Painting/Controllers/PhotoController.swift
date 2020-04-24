//
//  PhotoController.swift
//  AR_Painting
//
//  Created by Александр Королёв on 24.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {
  
  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBOutlet weak var photoView: UIImageView!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var topView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
  }
  
  func configureViews() {
    topView.backgroundColor = customBlueColor
    bottomView.backgroundColor = customPinkColor
  }
  
}
