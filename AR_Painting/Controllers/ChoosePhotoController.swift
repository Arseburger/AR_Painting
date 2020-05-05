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
  var image: UIImage?
  var galleryLoaded: Bool = false
  var selectedItem: (Item.Category, PHAsset?)?
  let numberOfItemsPerRow: CGFloat = 4
  let interItemSpacing: CGFloat = 6
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
  @IBAction func shiet(_ sender: Any) {
    self.getRandomPhoto()
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
  
  func validate() {
    if self.selectedItem != nil {
      button.isEnabled = false
    } else {
      button.isEnabled = true
    }
  }
  
  func prepareImage() {
    self.showLoadingState()
    if selectedItem?.0 == .unsplash {
      getRandomPhoto()
    } else {
      
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {  }
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
    return UIEdgeInsets(top: interItemSpacing, left: interItemSpacing * 0.5, bottom: interItemSpacing, right: interItemSpacing * 0.5)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.reuseIdentifier, for: indexPath) as! PhotoCollectionCell
    
    if self.selectedItem?.0 == Item.shared.item(at: indexPath)?.0 && self.selectedItem?.1 == Item.shared.item(at: indexPath)?.1 {
      collectionView.deselectItem(at: indexPath, animated: true)
      cell.isChecked = false
      selectedItem = nil
    } else {
      cell.isChecked = true
      self.selectedItem = dataSource.items.item(at: indexPath)
    }
    print(selectedItem)
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    collectionView.indexPathsForVisibleItems.forEach {
      guard let cell = collectionView.cellForItem(at: $0) as? PhotoCollectionCell else {
        return
      }
      cell.isChecked = false
      cell.starView.isHidden = true
    }

    
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.reuseIdentifier, for: indexPath) as! PhotoCollectionCell
//    collectionView.indexPathsForVisibleItems.forEach { _ in
//
//    }
//    cell.isChecked = false
//    cell.starView.isHidden = true
//    print(indexPath)
  }
  
}
