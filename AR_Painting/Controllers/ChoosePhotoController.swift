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
  
  var image: UIImage?
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.separatorStyle = .none
    tableView.isScrollEnabled = false
  }
  
}

extension ChoosePhotoController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleCell
      cell.label?.text = "Загрузить случайное фото"
      cell.label?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
      return cell
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "downloadSelectionCell", for: indexPath) as! DownloadSelectionCell
      return cell
      
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleCell
      cell.label?.text = "Выбрать фото из галереи"
      cell.label?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
      return cell
      
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: "albumSelectionCell", for: indexPath) as! AlbumSelectionCell
      return cell

    default:
      return UITableViewCell()
    }
  }
  
  func getUnsplashImage() {
    let indexPath = IndexPath(row: 1, section: 0)
    guard let cell = tableView.cellForRow(at: indexPath) as? DownloadSelectionCell else {
      return
    }
    self.image = cell.photo
    self.button.isEnabled = true
  }
  
}

extension ChoosePhotoController {
  
  func configureViews() {
    topView.backgroundColor = CustomColors.blue
    button.backgroundColor = CustomColors.pink
    button.setTitle("Выберите изображение", for: .disabled)
    button.setTitle("Готово", for: .normal)
//    button.isEnabled = false
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    self.getUnsplashImage()
  }
  
}
