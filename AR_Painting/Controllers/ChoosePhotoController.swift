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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    collectionView.dataSource = dataSource
    collectionView.delegate = delegate
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
  
  func getUserImages() -> PHFetchResult<PHAsset> {
    let options = PHFetchOptions()
    options.predicate = NSPredicate(format: "mediatype == %d", PHAssetMediaType.image.rawValue)
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    let images = PHAsset.fetchAssets(with: options)
    print(images.count)
    return images
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.image = self.getRandomPhoto()
  }
}
