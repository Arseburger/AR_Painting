//
//  PhotoController.swift
//  AR_Painting
//
//  Created by Александр Королёв on 24.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit
import Photos

class PhotoController: UIViewController {
  
  var image: UIImage?
  @IBOutlet weak var photoView: UIImageView!
  @IBOutlet weak var topView: UIView!
  
  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func share(_ sender: Any) {
    let activityController = UIActivityViewController(activityItems: [self.image!], applicationActivities: nil)
    self.present(activityController, animated: true, completion: nil)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
  }
  
  
  func configureViews() {
    topView.backgroundColor = CustomColors.blue
    photoView.image = image
  }
  
}
