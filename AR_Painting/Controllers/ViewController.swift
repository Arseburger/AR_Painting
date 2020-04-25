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

class ViewController: UIViewController, ARSCNViewDelegate {
  
  var photoNode: SCNNode!
  
  
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initSceneView()
    self.initScene()
    self.initARSession()
    self.loadModel()
    self.configureViews()
    sceneView.debugOptions = [.showWorldOrigin]
    
    
//    let scene = SCNScene(named: "art.scnassets/PictureScene.scn")!
//    sceneView.scene = scene
    
    
  }
  
  func initScene() {
    let scene = SCNScene()
    scene.isPaused = false
    sceneView.scene = scene
  }
  
  func initSceneView() {
    sceneView.delegate = self
    sceneView.showsStatistics = false
  }
  
  func initARSession() {
    guard ARWorldTrackingConfiguration.isSupported else {
      return
    }
    let config = ARWorldTrackingConfiguration()
    config.worldAlignment = .gravity
    config.providesAudioData = false
    config.environmentTexturing = .automatic
    config.planeDetection = .vertical
    sceneView.session.run(config)

  }
  
  func configureViews() {
    upperView.backgroundColor = customBlueColor
//    lowerView.backgroundColor = customPinkColor
    label.textColor = customPinkColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let configuration = ARWorldTrackingConfiguration()
    sceneView.session.run(configuration)
  }
  
  func createARPlaneNode(planeAnchor: ARPlaneAnchor, color: UIColor) -> SCNNode {
    let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.y))
    
    let planeMaterial = SCNMaterial()
    planeMaterial.diffuse.contents = "art.scnassets/Surface_Diffuse.png"
    planeGeometry.materials = [planeMaterial]
    
    let planeNode = SCNNode(geometry: planeGeometry)
    planeNode.position = SCNVector3Make(planeAnchor.extent.x, planeAnchor.extent.y, 0)
    
    planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 0, 1, 0)
    return planeNode
    
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else {
      return
    }
    DispatchQueue.main.async {
      let planeNode = self.createARPlaneNode(planeAnchor: planeAnchor, color: UIColor.yellow.withAlphaComponent(0.5))
      node.addChildNode(planeNode)
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else {
      return
    }
    DispatchQueue.main.async {
      self.updatePlaneNode(planeNode: node.childNodes[0], planeAnchor: planeAnchor)
    }
  }
  
  func updatePlaneNode(planeNode: SCNNode, planeAnchor: ARPlaneAnchor) {
    let planeGeometry = planeNode.geometry as! SCNPlane
    planeGeometry.width = CGFloat(planeAnchor.extent.x)
    planeGeometry.height = CGFloat(planeAnchor.extent.y)
    planeNode.position = SCNVector3Make(planeAnchor.extent.x, planeAnchor.extent.y, 0)
  }
  
  func loadModel() {
    let photoScene = SCNScene(named: "art.scnassets/PictureScene.scn")!
    photoNode = photoScene.rootNode.childNode(withName: "photo", recursively: false)
    sceneView.scene.rootNode.addChildNode(photoNode)
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
