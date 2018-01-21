//
//  ViewController.swift
//  Test App
//
//  Created by Hunter Hurja on 1/20/18.
//  Copyright © 2018 Hunter Hurja. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import MapKit
import ARCL


class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate {


    @IBOutlet var sceneView: SceneLocationView!
    let configuration = ARWorldTrackingConfiguration()
    let locationManager = CLLocationManager()
//    let sceneView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prevent the screen from being dimmed after a while.
        UIApplication.shared.isIdleTimerDisabled = true

        // Set the view's delegate
        sceneView.delegate = self

//        // Create a new scene
//        let scene = SCNScene()
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
        sceneView = SceneLocationView()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        
//        sceneLocationView.run()
        
        
//        let pinCoordinate = CLLocationCoordinate2D(latitude: 51.504607, longitude: -0.019592)
//        let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: 236)
//        let pinImage = UIImage(named: "pin")!
//        let pinLocationNode = LocationAnnotationNode(location: pinLocation, image: pinImage)
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
       
        let adamCoordinate = CLLocationCoordinate2D(latitude: 34.4102768, longitude: -119.8440762)
        let adamLocation = CLLocation(coordinate: adamCoordinate, altitude: 15)
        let adamImage = self.resizeImage(image: UIImage(named: "adam")!, targetSize: CGSize(width: 90.0, height: 90.0))
        let adamAnnotationNode = LocationAnnotationNode(location: adamLocation, image: adamImage)
        sceneView.addLocationNodeWithConfirmedLocation(locationNode: adamAnnotationNode)
        
        let testCoordinate = CLLocationCoordinate2D(latitude: 35.4186238, longitude: -119.4743797)
        let testLocation = CLLocation(coordinate: testCoordinate, altitude: 10)
        
        //        let adamImage = UIImage(named: "adam")!
        let testImage = self.resizeImage(image: UIImage(named: "test")!, targetSize: CGSize(width: 90.0, height: 90.0))
        let testAnnotationNode = LocationAnnotationNode(location: testLocation, image: testImage)
        sceneView.addLocationNodeWithConfirmedLocation(locationNode: testAnnotationNode)
        
        
        
        
//        let coordinate = CLLocationCoordinate2D(latitude: 34.4116289, longitude: -119.8491773)
//        let location = CLLocation(coordinate: coordinate, altitude: 10)
//
////        let locationNode = LocationNode(location: location)
////        locationNode.geometry?.firstMaterial?.diffuse.contents = "adam"
////        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
//
//        let image = UIImage(named: "test")!
//        let annotationNode = LocationAnnotationNode(location: location, image: image)
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
//
//
        view.addSubview(sceneView)
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneView.frame = view.bounds
    }
    
    
    func createObject(position: SCNVector3){
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        node.geometry?.firstMaterial?.diffuse.contents = "adam"
        node.position = position
        
        sceneView.scene.rootNode.addChildNode(node)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.run()

        // Run the view's session
//        sceneView.session.run(configuration)
        
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
    
    
    @IBAction func addButton(_ sender: Any) {
        
        //        let node = SCNNode()
        //        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        //        node.geometry?.firstMaterial?.diffuse.contents = "adam"
        //
        ////        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        ////        node.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        //
        //                node.position = SCNVector3(0, 0, 0)
        //        self.sceneView.scene.rootNode.addChildNode(node)
        
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        cubeNode.position = SCNVector3(0, 0, -0.2) // SceneKit/AR coordinates are in meters
        sceneView.scene.rootNode.addChildNode(cubeNode)
        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let myTouch = touches.first else { return }
        let result = sceneView.hitTest(myTouch.location(in: sceneView), types: ( ARHitTestResult.ResultType.featurePoint ) )
        guard let hitResult = result.last else { return }
//        let hitTransform = SCNMatrix4FromMat4((hitResult.worldTransform))
        let hitTransform = SCNMatrix4.init((hitResult.worldTransform))
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        createObject(position: hitVector)
        
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
        print("Session failed: \(error.localizedDescription)")
//        resetTracking()
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print( "Session was interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
//    private func resetTracking() {
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = .horizontal
//        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//    }
}
