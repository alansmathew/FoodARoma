//
//  BuildOwnViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-06-26.
//

import UIKit
import RealityKit
import ARKit
import Lottie

class BuildOwnViewController: UIViewController {

    @IBOutlet weak var topingsCollectionView: UICollectionView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var animation_lottie: LottieAnimationView!
    
    let topingNames = ["Size", "Mozzarella", "Cheddar", "Fontina" , "Chichen" ,"Beef", "Pepperoni", "Black olives", "Mushroom" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        animation_lottie.isHidden = false
        animation_lottie.animation = LottieAnimation.named("move.json")
        animation_lottie.animationSpeed = 0.9
        animation_lottie.loopMode = .loop
        animation_lottie.play()
        
        topingsCollectionView.dataSource = self
        topingsCollectionView.delegate = self
        topingsCollectionView.isHidden = true
    }


}

extension BuildOwnViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        let planeNode = createPlaneNode(anchor: planeAnchor)
        node.addChildNode(planeNode)
        
        DispatchQueue.main.async {
            self.animation_lottie.stop()
            self.animation_lottie.isHidden = true
        }
    }
    
    private func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        
        
        // Create a transparent plane with visible borders
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        plane.materials.first?.diffuse.contents = UIColor.clear
        plane.materials.first?.isDoubleSided = true // Show both sides of the plane

        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.eulerAngles.x = -.pi / 2 // Rotate the plane to be horizontal

        // Add a border using a plane with a visible color
        let border = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        border.materials.first?.diffuse.contents = UIColor(red: 1.00, green: 0.61, blue: 0.00, alpha: 0.75)
        border.materials.first?.isDoubleSided = true

        let borderNode = SCNNode(geometry: border)
        borderNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        borderNode.eulerAngles.x = -.pi / 2 // Rotate the border plane to be horizontal

        // Combine the transparent plane and the border plane in a single node
        let planeContainerNode = SCNNode()
        planeContainerNode.addChildNode(planeNode)
        planeContainerNode.addChildNode(borderNode)

//        return planeContainerNode
        
        
        let scaleUpAction = SCNAction.scale(to: 1.2, duration: 0.5)
        let scaleDownAction = SCNAction.scale(to: 1.0, duration: 0.5)
        let pulsateAction = SCNAction.sequence([scaleUpAction, scaleDownAction])
        let pulsateForeverAction = SCNAction.repeatForever(pulsateAction)

        planeContainerNode.runAction(pulsateForeverAction)
        planeContainerNode.name = "planeNode"

        return planeContainerNode
        
    }
}

extension BuildOwnViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let result = sceneView.hitTest(touch.location(in: sceneView), types: [.existingPlaneUsingExtent]).first else { return }

        let position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        let objectNode = createYour3DObject() // Create your 3D object node here
        
        objectNode.position = position
        sceneView.scene.rootNode.addChildNode(objectNode)
        
        DispatchQueue.main.async {
            self.topingsCollectionView.isHidden = false
        }
        
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            print(node.name)
              if node.name == "planeNode" {
                  node.removeFromParentNode()
              }
          }
    }
    
    private func createYour3DObject() -> SCNNode {
        
        
        // Load the USDZ model
        let url = Bundle.main.url(forResource: "title1", withExtension: "usdz")
        let scene = try? SCNScene(url: url!)
        let objectNode = scene!.rootNode.childNodes.first
        return objectNode!
        
    }
}

extension BuildOwnViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topingNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = topingsCollectionView.dequeueReusableCell(withReuseIdentifier: "topingsCellIdentifier", for: indexPath) as! PizzaTopingsCustomCollectionViewCell
        cell.topingsNameLabel.text = topingNames[indexPath.row]
        cell.topingsImage.image = UIImage(named: topingNames[indexPath.row])
        return cell
    }
    

}

extension BuildOwnViewController : UICollectionViewDelegate{
    
}


class PizzaTopingsCustomCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var contentViewBackground: UIView!
    @IBOutlet weak var topingsImage: UIImageView!
    @IBOutlet weak var topingsNameLabel: UILabel!
    override func awakeFromNib() {
        contentViewBackground.layer.cornerRadius = 10
        contentViewBackground.layer.borderWidth = 1
        contentViewBackground.layer.borderColor = UIColor.orange.cgColor
    }
    
}
