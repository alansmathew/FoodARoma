//
//  BuildOwnViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-06-26.
//

import UIKit
import RealityKit
import ARKit

class BuildOwnViewController: UIViewController {

    @IBOutlet weak var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arView.session.delegate = self
        
        setupARView()
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    func setupARView() {
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
    }
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        print("happpenes")
        let location = recognizer.location(in: arView)
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment:.horizontal)
        print(results)
        if let firstResult = results.first {
            let anchor = ARAnchor (name: "title1", transform: firstResult.worldTransform)
            print(anchor)
            arView.session.add(anchor: anchor)
        }
        else {
            print("Object placement failed - couldn't find surface.")
        }
    }
    
    func placeObject(named entityName: String, for anchor : ARAnchor){
        print(anchor)
        let entity = try! ModelEntity.load(named: entityName)
        
//        entity.generateCollisionShapes(recursive: true)
//        arView.installGestures([.rotation,.translation], for: entity as! Entity & HasCollision)
        
//        let anchorEntity = AnchorEntity(anchor: anchor)
//        anchorEntity.addChild(entity)
//        arView.scene.addAnchor((anchorEntity))
    }

}

extension BuildOwnViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == "title1" {
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}
