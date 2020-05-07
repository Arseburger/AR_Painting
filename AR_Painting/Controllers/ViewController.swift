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
  var center: CGPoint {
    return CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
  }
  var picturePlanes: [SCNNode] = []
  var pictureNode: SCNNode? = nil
  var sceneHasPicture: Bool = false
  
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
  
  @IBAction func reset(_ sender: Any) {
    self.runSession()
    self.removePicturePlanes()
    self.removeAllNodes()
  }
  
  //MARK: Methods -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.getPhotoAccess()
    self.initScene()
    self.configureViews()
    self.configureCrosshair()
  }
  
  func configureViews() {
    upperView.backgroundColor = CustomColors.blue
    self.initSceneView()
  }
  
  func configureCrosshair() {
    crosshair.layer.cornerRadius = crosshair.frame.width * 0.5
    smallCrosshair.layer.cornerRadius = smallCrosshair.frame.width * 0.5
    smallCrosshair.isHidden = true
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let hit = sceneView.hitTest(center, types: [.existingPlaneUsingExtent]).first {
      sceneView.session.add(anchor: ARAnchor.init(transform: hit.worldTransform))
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.runSession()
    self.removePicturePlanes()
    self.removeAllNodes()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sceneView.session.pause()
  }
  
  func update(image: UIImage?) {
    self.planeImage = image
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
  
  func removePicturePlanes() {
    for picturePlaneNode in self.picturePlanes {
      picturePlaneNode.removeFromParentNode()
    }
    self.picturePlanes = []
  }
  
}

extension ViewController {
  
  // MARK: ARManagment -
  
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
    sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    sceneView.delegate = self
  }
  
  func removeAllNodes() {
    removePicturePlanes()
    self.pictureNode?.removeFromParentNode()
    self.sceneHasPicture = false
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    DispatchQueue.main.async {
      if let planeAnchor = anchor as? ARPlaneAnchor, !self.sceneHasPicture {
        
        let debugPlaneNode = self.createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent)
        node.addChildNode(debugPlaneNode)
        self.picturePlanes.append(debugPlaneNode)
       
      } else if !self.sceneHasPicture {
        
        self.pictureNode = self.makePicture()
        if let picture = self.pictureNode {
         
          node.addChildNode(picture)
          self.sceneHasPicture = true
          self.removePicturePlanes()
          self.sceneView.debugOptions = []
          
        }
      }
    }
  }
  
//  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//    DispatchQueue.main.async {
//      if let planeAnchor = anchor as? ARPlaneAnchor, node.childNodes.count > 0, !self.sceneHasPicture {
//        self.updatePlaneNode(node.childNodes[0], center: planeAnchor.center, extent: planeAnchor.extent)
//      }
//    }
//  }
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    DispatchQueue.main.async {
      if let _ = self.sceneView.hitTest(self.center, types: [.existingPlaneUsingExtent]).first {
        self.smallCrosshair.isHidden = false
      } else {
        self.smallCrosshair.isHidden = true
      }
    }
  }
  
  func makePicture() -> SCNNode {
    let picture = SCNNode()
    let maxSide = max((self.planeImage?.size.width)!, (self.planeImage?.size.height)!)
    let width = (self.planeImage?.size.width)!
    let height = (self.planeImage?.size.height)!
    let image = SCNPlane(width: 0.5 * width / maxSide, height: 0.5 * height / maxSide)
    let material = SCNMaterial()
    material.diffuse.contents = self.planeImage
    image.materials = [material]
    let imageNode = SCNNode(geometry: image)
    imageNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
    picture.addChildNode(imageNode)
    return picture
  }
  
  func updatePlaneNode(_ node: SCNNode, center: vector_float3, extent: vector_float3) {
    let geometry = node.geometry as? SCNPlane
    
    geometry?.width = CGFloat(extent.x)
    geometry?.height = CGFloat(extent.z)
    node.position = SCNVector3Make(center.x, 0, center.z)
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
