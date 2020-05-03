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
  let delegate = CollectionViewDelegate(numberOfItemsPerRow: 5, interItemSpacing: 10)
  
  var image: UIImage?
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var bottomView: UIView!
  
  @IBOutlet weak var overlayView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func showLoader(_ sender: Any) {
    showLoadingState()
    print(Item.shared.getUserImages().count)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    collectionView.dataSource = dataSource
    collectionView.delegate = delegate
    collectionView.reloadData()
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
  
  func getRandomPhoto() -> UIImage {
    var image = UIImage()
    let service = BaseService()
    self.showLoadingState()
    service.loadRandomPhoto(onComplete: { photos in
      DispatchQueue.global().async {
        let url = URL(string: (photos.urls.regular))
        let data = try? Data(contentsOf: url!)
        image = UIImage(data: data!)!
      }
    }) { error in print("mimo") }
    return image
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.image = self.getRandomPhoto()
  }
}
