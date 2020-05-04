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
import CoreGraphics
import Photos

class ViewController: UIViewController, ARSCNViewDelegate {
  
  var photoNode: SCNNode!
  var pointerNode: SCNNode?
  var planeImage: UIImage? = UIImage(named: "art.scnassets/Textures/bird.jpeg")
  var sceneHasPicture: Bool = false
  var arrow: SCNNode!
  var focusPoint: CGPoint!
  
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var testButton: UIButton!
  
  @IBAction func test(_ sender: Any) {
    self.update(image: self.planeImage == UIImage(named: "art.scnassets/Textures/guy.jpg") ? UIImage(named: "art.scnassets/Textures/bird.jpeg") : UIImage(named: "art.scnassets/Textures/guy.jpg"))
    print("Button pressed")
  }
  
  @IBAction func saveNewImage(_ unwindSegue: UIStoryboardSegue) {
    guard unwindSegue.identifier == "passImageBack" else {
      return
    }
    guard let source = unwindSegue.source as? ChoosePhotoController else {
      return
    }
    guard source.image != nil else {
      return
    }
    self.planeImage = source.image
  }
  
  @IBAction func swipeUpGestureHandler(_ sender: Any) {
    guard let frame = self.sceneView.session.currentFrame else {
      return
    }
    guard !self.sceneHasPicture else {
      return
    }
    self.applyImage(transform: SCNMatrix4(frame.camera.transform), offset: SCNVector3(x: 0.0, y: 0.0, z: -2.0))
    self.sceneHasPicture = true
//    print("+", self.planeImage)
  }
  
  @IBAction func swipeDownGestureHandler(_ sender: Any) {
    guard self.sceneHasPicture else {
      return
    }
    self.sceneView.scene.rootNode.childNode(withName: "picturePlane", recursively: false)?.removeFromParentNode()
    self.sceneHasPicture = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initSceneView()
    self.initScene()
    self.initARSession()
    self.update(image: self.planeImage)
    self.configureViews()
    self.updatePlaneNode()
    self.getPhotoAccess()
    self.loadModel()
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
    config.worldAlignment = .camera
    config.providesAudioData = false
    config.environmentTexturing = .automatic
    config.planeDetection = .vertical
    sceneView.session.run(config)

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
  
  func session(_ session: ARSession, didFailWithError error: Error) {
  }

  func sessionWasInterrupted(_ session: ARSession) {
  }

  func sessionInterruptionEnded(_ session: ARSession) {
  }
  
}

extension ViewController {
  
  func createARPlaneNode(planeAnchor: ARPlaneAnchor, color: UIColor) -> SCNNode {
    let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.y))
    
    let planeMaterial = SCNMaterial()
    planeMaterial.diffuse.contents = "art.scnassets/Textures/whiteDots_Diffuse.png"
    planeGeometry.materials = [planeMaterial]
    
    let planeNode = SCNNode(geometry: planeGeometry)
    planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, 0)
    
    return planeNode
    
  }
  
  func updatePlaneNode(planeNode: SCNNode, planeAnchor: ARPlaneAnchor) {
    let planeGeometry = planeNode.geometry as! SCNPlane
    planeGeometry.width = CGFloat(planeAnchor.extent.x)
    planeGeometry.height = CGFloat(planeAnchor.extent.y)
    planeNode.position = SCNVector3Make(planeAnchor.extent.x, planeAnchor.extent.y, 0)
  }
  
  func applyImage(transform: SCNMatrix4, offset: SCNVector3) {
    
    let position = SCNVector3(transform.m41 + offset.x,
                            transform.m42 + offset.y,
                            transform.m43 + offset.z)
    
    let width = self.planeImage?.size.width
    let height = self.planeImage?.size.height
    let maxMeasure = CGFloat(max(width!, height!))
    
    let material = SCNMaterial()
    material.diffuse.contents = self.planeImage
    
    let geometry = SCNPlane(width: width! / maxMeasure, height: height! / maxMeasure)
    geometry.materials = [material]
    
    let imageNode = SCNNode(geometry: geometry)
    imageNode.position = position
    imageNode.name = "picturePlane"
    
    sceneView.scene.rootNode.addChildNode(imageNode)
    
  }
  
  func updatePlaneNode() {
    
  }
  
  func update(image: UIImage?) {
    self.planeImage = image
  }
  
  func loadModel() {
    let photoScene = SCNScene(named: "art.scnassets/Models/PictureScene.scn")!
//    photoNode = photoScene.rootNode.childNode(withName: "photo", recursively: false)
//    photoNode!.geometry?.firstMaterial?.diffuse.contents = self.planeImage
//    photoNode!.isHidden = false
//    sceneView.scene.rootNode.addChildNode(photoNode)
    let arrowScene = SCNScene(named: "art.scnassets/Models/ArrowScene.scn")
    arrow = arrowScene?.rootNode.childNode(withName: "arrow", recursively: false)
    sceneView.scene.rootNode.addChildNode(arrow)
  }
  
  func configureViews() {
    upperView.backgroundColor = CustomColors.blue
    testButton.layer.cornerRadius = 30
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "passImage" else {
      return
    }
    guard let destination = segue.destination as? PhotoController else {
      return
    }
    
    let picture = self.sceneView.snapshot()
    destination.image = picture
  }
  
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
  
  
}
