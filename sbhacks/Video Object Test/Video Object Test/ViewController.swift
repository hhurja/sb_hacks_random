//
//  ViewController.swift
//  Video Object Test
//
//  Created by Hunter Hurja on 1/21/18.
//  Copyright © 2018 Hunter Hurja. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A SpriteKit scene to contain the SpriteKit video node
        let spriteKitScene = SKScene(size: CGSize(width: sceneView.frame.width, height: sceneView.frame.height))
        spriteKitScene.scaleMode = .aspectFit
        
        // Create a video player, which will be responsible for the playback of the video material
        let videoUrl = Bundle.main.url(forResource: "videos/video", withExtension: "mp4")!
        let videoPlayer = AVPlayer(url: videoUrl)
        
        // To make the video loop
        videoPlayer.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.playerItemDidReachEnd),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: videoPlayer.currentItem)
        
        // Create the SpriteKit video node, containing the video player
        let videoSpriteKitNode = SKVideoNode(avPlayer: videoPlayer)
        videoSpriteKitNode.position = CGPoint(x: spriteKitScene.size.width / 2.0, y: spriteKitScene.size.height / 2.0)
        videoSpriteKitNode.size = spriteKitScene.size
        videoSpriteKitNode.yScale = -1.0
        videoSpriteKitNode.play()
        spriteKitScene.addChild(videoSpriteKitNode)
        
        // Create the SceneKit scene
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.isPlaying = true
        
        // Create a SceneKit plane and add the SpriteKit scene as its material
        let background = SCNPlane(width: CGFloat(100), height: CGFloat(100))
        background.firstMaterial?.diffuse.contents = spriteKitScene
        let backgroundNode = SCNNode(geometry: background)
        scene.rootNode.addChildNode(backgroundNode)
    }
    
    // This callback will restart the video when it has reach its end
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
