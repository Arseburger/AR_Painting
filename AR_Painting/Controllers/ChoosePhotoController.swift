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
    tableView.register(TitleCell.self, forCellReuseIdentifier: "DownloadTitle")
    tableView.register(DownloadSelectionCell.self, forCellReuseIdentifier: "DownloadSelection")
    tableView.register(TitleCell.self, forCellReuseIdentifier: "AlbumTitle")
    tableView.register(AlbumSelectionCell.self, forCellReuseIdentifier: "AlbumSelection")
    tableView.separatorStyle = .none
  }
  
  func configureViews() {
    topView.backgroundColor = customBlueColor
    button.backgroundColor = customPinkColor
  }
  
}

extension ChoosePhotoController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     4
   }
   
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadTitle", for: indexPath) as! TitleCell
        cell.textLabel?.text = "Загрузить случайное фото"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        return cell 
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadSelection", for: indexPath) as! DownloadSelectionCell
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTitle", for: indexPath) as! TitleCell
      cell.textLabel?.text = "Выбрать фото из галереи"
      cell.textLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
      return cell
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumSelection", for: indexPath) as! AlbumSelectionCell
      return cell
    default:
      return UITableViewCell()
    }
  }
  
}
