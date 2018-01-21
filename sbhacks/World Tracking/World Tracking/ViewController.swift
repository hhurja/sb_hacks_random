//
//  ViewController.swift
//  World Tracking
//
//  Created by Hunter Hurja on 1/20/18.
//  Copyright © 2018 Hunter Hurja. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {

    
   
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin] 
        self.sceneView.session.run(configuration)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func view (_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
        let node = SKSpriteNode(imageNamed: "test")
        
        return node;
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, nodeFor anchor: ARAnchor) {
        // This visualization covers only detected planes.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a SceneKit plane to visualize the node using its position and extent.
//        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//        let planeNode = SCNNode(geometry: plane)
//
//        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
//
//        // SCNPlanes are vertically oriented in their local coordinate space.
//        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        let cubeNode = SCNNode()
        cubeNode.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        cubeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        cubeNode.geometry?.firstMaterial?.diffuse.contents = "adam"
        
        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(cubeNode)
    }

    @IBAction func add(_ sender: Any) {
//        let node = SCNNode()
//        node.geometry = SCNBox(width: 1, height: 1, length: 0.0000001, chamferRadius: 0)
//
//        let targetNode = SCNNode()
//        let y_val = 0.5*Float(arc4random()) / Float(UINT32_MAX)
//        targetNode.position = SCNVector3(CGFloat(0), CGFloat(y_val), CGFloat(0))
//        let lookat = SCNLookAtConstraint(target: targetNode)
//        node.constraints = [lookat]
//
//        node.geometry?.firstMaterial?.diffuse.contents = "adam"
//        node.position = SCNVector3(CGFloat( 10.0 - 20.0*(Float(arc4random()) / Float(UINT32_MAX)) ),
//                                   CGFloat(CGFloat(y_val) ),
//                                   CGFloat(10.0 - 20.0*(Float(arc4random()) / Float(UINT32_MAX))))
//        self.sceneView.scene.rootNode.addChildNode(node)
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//        node.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)

//        node.position = SCNVector3(CGFloat(3.0-Float(arc4random_uniform(3))),
//                                   CGFloat(3.0-Float(arc4random_uniform(3))),
//                                   CGFloat(Float(arc4random_uniform(3))) )

        
        
        let videoURL = Bundle.main.url(forResource: "IMG_1930", withExtension: "m4v")!
        let player = AVPlayer(url: videoURL)
        
        // To make the video loop
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.playerItemDidReachEnd),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.currentItem)
        
        let videoNode = SKVideoNode(avPlayer: player)
        let size = CGSize(width: 1024, height: 512)
        videoNode.size = size
        videoNode.position = CGPoint(x: 512, y: 256)
        videoNode.yScale = -1.0
        let spriteScene = SKScene(size: size)
        videoNode.play()
        
        spriteScene.addChild(videoNode)
        
        
        let node = SCNNode()
        node.geometry = SCNBox(width: 1, height: 1, length: 0.0000001, chamferRadius: 0)
        
        let targetNode = SCNNode()
        let y_val = 0.5*Float(arc4random()) / Float(UINT32_MAX)
        targetNode.position = SCNVector3(CGFloat(0), CGFloat(y_val), CGFloat(0))
        let lookat = SCNLookAtConstraint(target: targetNode)
        node.constraints = [lookat]

        node.geometry?.firstMaterial?.diffuse.contents = spriteScene
        node.position = SCNVector3(CGFloat( 10.0 - 20.0*(Float(arc4random()) / Float(UINT32_MAX)) ),
                                   CGFloat(CGFloat(y_val) ),
                                   CGFloat(10.0 - 20.0*(Float(arc4random()) / Float(UINT32_MAX))))
        self.sceneView.scene.rootNode.addChildNode(node)

        node.position = SCNVector3(CGFloat(3.0-Float(arc4random_uniform(3))),
                                   CGFloat(3.0-Float(arc4random_uniform(3))),
                                   CGFloat(Float(arc4random_uniform(3))) )
        
        self.sceneView.scene.rootNode.addChildNode(node)
//        self.sceneView.isPlaying = true
//        self.sceneView.loops = true
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero)
        }
    }

    
    
    
}


