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
  
  // MARK: Properties -
  
  var photoNode: SCNNode!
  var planeImage: UIImage? = UIImage(named: "art.scnassets/Textures/bird.jpeg")
  var sceneHasPicture: Bool = false
  var imagePlaceholder: SCNNode? = SCNScene(named: "art.scnassets/Models/PictureScene.scn")?.rootNode.childNode(withName: "placeholder", recursively: false)
  var center: CGPoint {
    return CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
  }
  
  //MARK: IBOutlets -
  
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var crosshair: UIView!
  @IBOutlet weak var smallCrosshair: UIView!
  
  //MARK: IBActions -
  
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
    self.update(image: source.image)
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
    self.crosshair.isHidden = true
  }
  
  @IBAction func swipeDownGestureHandler(_ sender: Any) {
    guard self.sceneHasPicture else {
      return
    }
    self.sceneView.scene.rootNode.childNode(withName: "placeholder", recursively: false)?.removeFromParentNode()
    self.sceneHasPicture = false
    self.crosshair.isHidden = false
  }
  
  //MARK: Methods -
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    self.initSceneView()
    self.initScene()
//    self.runSession()
    self.configureViews()
    self.configureCrosshair()
  }
  
  func configureViews() {
    upperView.backgroundColor = CustomColors.blue
  }
  
  func configureCrosshair() {
    crosshair.layer.cornerRadius = crosshair.frame.width * 0.5
    smallCrosshair.layer.cornerRadius = smallCrosshair.frame.width * 0.5
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
  
  //MARK: ARManagment -
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.runSession()
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
  
  func runSession() {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .vertical
    configuration.isLightEstimationEnabled = true
    sceneView.session.run(configuration)
    
    #if DEBUG
    sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    #endif
    
    sceneView.delegate = self
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    DispatchQueue.main.async {
      if let planeAnchor = anchor as? ARPlaneAnchor {
        #if DEBUG
        let debugPlaneNode = self.createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent)
        node.addChildNode(debugPlaneNode)
        #endif
      }
    }
  }
  
}

extension ViewController {
  
  // MARK: Surfaces -
  
  func updateARPlaneNode(planeNode: SCNNode, planeAnchor: ARPlaneAnchor) { }
  
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
  
  func update(image: UIImage?) {
    self.planeImage = image
  }
  
  func createPlaneNode(center: vector_float3, extent: vector_float3) -> SCNNode {
    
    let plane = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
    
    let planeMaterial = SCNMaterial()
    planeMaterial.diffuse.contents = UIImage(named: "art.scnassets/Textures/ImagePlaceholder.png")
    plane.materials = [planeMaterial]
    
    let planeNode = SCNNode(geometry: plane)
    planeNode.position = SCNVector3Make(center.x, 0, center.z)
    planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
    
    return planeNode
  }

}
