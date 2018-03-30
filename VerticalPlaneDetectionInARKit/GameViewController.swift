//
//  GameViewController.swift
//  VerticalPlaneDetectionInARKit
//
//  Created by Alex Nagy on 30/03/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import ARKit

class GameViewController: UIViewController, ARSCNViewDelegate {
  
  let arView: ARSCNView = {
    let view = ARSCNView()
    view.translatesAutoresizingMaskIntoConstraints = true
    return view
  }()
  
  let configuration = ARWorldTrackingConfiguration()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    view.addSubview(arView)
    
    arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    
    arView.session.run(configuration, options: [])
    
  }
  
  func createWall(anchor: ARPlaneAnchor) -> SCNNode {
    let wall = SCNNode()
    wall.name = "wall"
    wall.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.y))
    wall.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Wall")
    wall.position = SCNVector3(anchor.extent.x, anchor.extent.y, anchor.extent.z)
    return wall
  }
  
  func removeNode(named: String) {
    arView.scene.rootNode.enumerateChildNodes { (node, _) in
      if node.name == named {
        node.removeFromParentNode()
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let anchorPlane = anchor as? ARPlaneAnchor else { return }
    print("New plane anchor found with extent:", anchorPlane.extent)
    let wall = createWall(anchor: anchorPlane)
    node.addChildNode(wall)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let anchorPlane = anchor as? ARPlaneAnchor else { return }
    print("Plane anchor updated with extent:", anchorPlane.extent)
    let wall = createWall(anchor: anchorPlane)
    node.addChildNode(wall)
  }

  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    guard let anchorPlane = anchor as? ARPlaneAnchor else { return }
    print("Plane anchor removed with extent:", anchorPlane.extent)
    removeNode(named: "wall")
  }

}

