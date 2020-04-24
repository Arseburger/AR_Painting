//
//  ChoosePhotoController.swift
//  AR_Painting
//
//  Created by Александр Королёв on 24.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class ChoosePhotoController: UIViewController {
  

  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var button: UIButton!
  
  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
  }
  
  func configureViews() {
    topView.backgroundColor = customBlueColor
    button.backgroundColor = customPinkColor
  }
  
  
}
