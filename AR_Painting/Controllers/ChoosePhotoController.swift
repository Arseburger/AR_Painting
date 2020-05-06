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
  
  // MARK: Properties -
  
  let dataSource = DataSource()
  
  var image: UIImage? {
    didSet {
      print("got image")
    }
  }
  
  var selectedItem: (Item.Category, PHAsset?)? = nil {
    didSet {
      if selectedItem?.0 == .unsplash {
        getRandomPhoto { _ in return}
      } else if selectedItem?.1 != nil {
        getImage(from: (self.selectedItem?.1)!) { _ in return }
      }
      self.validate()
    }
  }
  
  let numberOfItemsPerRow: CGFloat = 5
  let interItemSpacing: CGFloat = 10
  var cellSize: CGSize {
    let maxWidth = UIScreen.main.bounds.width
    let scaling = interItemSpacing * numberOfItemsPerRow
    let itemSide = (maxWidth - scaling) / numberOfItemsPerRow
    return CGSize(width: itemSide, height: itemSide)
  }
  
  // MARK: IBOutlets -
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var overlayView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: IBActions -
  
  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func passImage(_ sender: Any) {
    
//    self.showLoadingState()
//
//    self.prepareImage { [weak self] (image: UIImage?) in
//
//      guard let image = image else {
//        return
//      }
//      self?.image = image
//
//    }
//    self.hideLoadingState()
  }
  
  // MARK: Methods -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.getPhotoAccess()
    configureViews()
    dataSource.items.getUserImages()
    collectionView.dataSource = dataSource
    collectionView.delegate = self
    validate()
    collectionView.reloadData()
  }
  
}

extension ChoosePhotoController {
  
  func getPhotoAccess() {
    let status = PHPhotoLibrary.authorizationStatus()
    
    DispatchQueue.main.async {
      switch status {
      default:
        PHPhotoLibrary.requestAuthorization { status in
          switch status {
          default:
            break
          }
        }
      }
    }
  }
  
  func configureViews() {
    topView.backgroundColor = CustomColors.blue
    button.backgroundColor = UIColor.white
    button.layer.cornerRadius = 10
    button.setTitleColor(UIColor.lightGray, for: .disabled)
    button.setTitleColor(CustomColors.blue, for: .normal)
    button.setTitle("Выберите изображение", for: .disabled)
    button.setTitle("Готово", for: .normal)
    overlayView.isHidden = true
    activityIndicator.isHidden = true
  }
  
  func showLoadingState() {
    self.activityIndicator.isHidden = false
    self.overlayView.isHidden = false
    self.activityIndicator.startAnimating()
    self.button.isEnabled = false
    self.button.setTitle("Загрузка", for: .disabled)
//    self.view.bringSubviewToFront(overlayView)
  }
  
  func hideLoadingState() {
    self.activityIndicator.stopAnimating()
    self.activityIndicator.isHidden = true
    self.overlayView.isHidden = true
    self.button.isEnabled = true
//    self.view.sendSubviewToBack(overlayView)
  }
 
  func validate() {
    if self.selectedItem == nil {
      button.isEnabled = false
    } else {
      button.isEnabled = true
    }
  }
  
  func getRandomPhoto(completion: (UIImage?) -> Void) {
    var image = UIImage()
    let service = BaseService()
    service.loadRandomPhoto(onComplete: { photos in
        let url = URL(string: (photos.urls.regular))
        let data = try? Data(contentsOf: url!)
        image = UIImage(data: data!)!
      
      print("done")
      self.image = image
    }) { error in print("mimo") }
  }
  
  func getImage(from asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
    let options = PHImageRequestOptions()
    options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
    PHImageManager().requestImage(for: asset, targetSize: .init(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .default, options: options) { assetImage, _  in
      self.image = assetImage
    }
    print("asset")
  }
  
  func prepareImage(completion: @escaping (UIImage?) -> Void) {
    if selectedItem?.0 == .unsplash {
      self.getRandomPhoto(completion: completion)
    } else {
      self.getImage(from: (selectedItem?.1!)!, completion: completion)
    }
  }
  
}

extension ChoosePhotoController: UICollectionViewDelegateFlowLayout {
  
  // MARK: Delegate methods -
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return cellSize
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return interItemSpacing * 0.5
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
    if section == 0 {
      return UIEdgeInsets(top: interItemSpacing, left: interItemSpacing, bottom: interItemSpacing, right: interItemSpacing)
    } else {
      return UIEdgeInsets(top: interItemSpacing, left: interItemSpacing * 0.5, bottom: interItemSpacing, right: interItemSpacing * 0.5)
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if selectedItem?.0 == dataSource.items.item(at: indexPath)?.0 && selectedItem?.1 == dataSource.items.item(at: indexPath)?.1 {
      collectionView.indexPathsForSelectedItems?.forEach {
        (collectionView.cellForItem(at: $0) as! PhotoCollectionCell).starView.isHidden = true
      }
      selectedItem = nil
    } else {
      selectedItem = dataSource.items.item(at: indexPath)
    }
    print(selectedItem)
  }

}

