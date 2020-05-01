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
  
  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func savePhoto(_ sender: Any) {
    self.savePhoto()
  }
  
  @IBOutlet weak var photoView: UIImageView!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var topView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    self.photoView.image = image
  }
  
  func savePhoto() {
    let status = PHPhotoLibrary.authorizationStatus()
    
    DispatchQueue.main.async {
      switch status {
      case .restricted, .denied:
        self.present(self.showGetAccessAlert(), animated: true)
      case .authorized:
        UIImageWriteToSavedPhotosAlbum(self.image!, nil, nil, nil)
        self.present(self.showCompletedAlert(), animated: true)
      default:
        PHPhotoLibrary.requestAuthorization { status in
          switch status {
          case .authorized:
            UIImageWriteToSavedPhotosAlbum(self.image!, nil, nil, nil)
            self.present(self.showCompletedAlert(), animated: true)
          case .restricted, .denied:
            self.present(self.showGetAccessAlert(), animated: true)
          default:
            break
          }
        }
      }
    }
  }
  
  func configureViews() {
    topView.backgroundColor = CustomColors.blue
    bottomView.backgroundColor = CustomColors.pink
  }
  
  func showCompletedAlert() -> UIViewController {
    let alert = UIAlertController(title: "Успешно", message: "Фоторгафия была сохранена в библиотеку.", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return alert
  }
  
  func showGetAccessAlert() -> UIViewController {
    let alert = UIAlertController(title: "Внимание", message: "Разрешите приложению доступ к фотографиям.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Понятно", style: .cancel, handler: nil))
    return alert
  }
}
