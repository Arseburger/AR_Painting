//
//  ChoosePhotoController.swift
//  AR_Painting
//
//  Created by Александр Королёв on 24.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit
import Photos

class ChoosePhotoController: UIViewController {
  
  let dataSource = DataSource()
  let delegate = CollectionViewDelegate(numberOfItemsPerRow: 3, interItemSpacing: 6)
  var image: UIImage?
  var galleryLoaded: Bool = false
  var selectedItem: Item?
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var bottomView: UIView!
  
  @IBOutlet weak var overlayView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func shiet(_ sender: Any) {
    self.getRandomPhoto()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    collectionView.dataSource = dataSource
    collectionView.delegate = delegate
    
//    if galleryLoaded == false {
//      dataSource.items.getImages()
//      self.collectionView.reloadData()
//      galleryLoaded = true
//    }
  }
  
}

extension ChoosePhotoController {
  
  func configureViews() {
    topView.backgroundColor = CustomColors.blue
    button.backgroundColor = UIColor.white
    button.layer.cornerRadius = 10
    button.setTitleColor(UIColor.lightGray, for: .disabled)
    button.setTitleColor(CustomColors.blue, for: .normal)
    button.setTitle("Выберите изображение", for: .disabled)
    button.setTitle("Готово", for: .normal)
    button.isEnabled = true
    overlayView.isHidden = true
    activityIndicator.isHidden = true
  }
  
  func showLoadingState() {
    self.activityIndicator.isHidden = false
    self.overlayView.isHidden = false
    self.activityIndicator.startAnimating()
    self.button.isEnabled = false
    self.button.setTitle("Загрузка", for: .disabled)
    self.view.bringSubviewToFront(overlayView)
  }
  
  func hideLoadingState() {
    self.activityIndicator.stopAnimating()
    self.activityIndicator.isHidden = true
    self.overlayView.isHidden = true
    self.button.isEnabled = true
    self.view.sendSubviewToBack(overlayView)
  }
  
  func getRandomPhoto() {
    var image = UIImage()
    let service = BaseService()
    self.showLoadingState()
    service.loadRandomPhoto(onComplete: { photos in
      DispatchQueue.main.async {
        let url = URL(string: (photos.urls.regular))
        let data = try? Data(contentsOf: url!)
        image = UIImage(data: data!)!
      }
      
      
      print("done")
      self.image = image
    }) { error in print("mimo") }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  }
}
