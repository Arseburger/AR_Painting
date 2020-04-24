//
//  ViewController.swift
//  AR_Painting
//
//  Created by Александр Королёв on 15.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Photos

class ViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var lowerView: UIView!
  @IBOutlet weak var label: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    
    sceneView.delegate = self
    sceneView.showsStatistics = false
    let scene = SCNScene(named: "art.scnassets/PictureScene.scn")!
    sceneView.scene = scene
  }
  
  func configureViews() {
    upperView.backgroundColor = customBlueColor
    lowerView.backgroundColor = customPinkColor
    label.textColor = customPinkColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let configuration = ARWorldTrackingConfiguration()
    sceneView.session.run(configuration)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    sceneView.session.pause()
  }
  

  
  func session(_ session: ARSession, didFailWithError error: Error) {
    
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
  }
  
}
