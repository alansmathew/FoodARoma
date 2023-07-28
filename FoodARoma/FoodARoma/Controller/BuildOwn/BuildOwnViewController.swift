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

    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var sideLabel: UILabel!
    @IBOutlet weak var sidebar: UIView!
    @IBOutlet weak var minusbutton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var sideOptions: UIView!
    @IBOutlet weak var topContentView: UIView!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var baclofBlurView: UIView!
    @IBOutlet weak var blurTopView: UIView!
    @IBOutlet weak var topingsCollectionView: UICollectionView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var animation_lottie: LottieAnimationView!
    
    let topingNames = ["Size", "Cheddar", "Fontina" , "Chichen" ,"Beef", "Pepperoni", "Black olives", "Mushroom" ]
    let toppingsSize = ["None", "Small", "Medium", "Large"]
    
    var cellSellection = 0
    var topingDefault = 2
    
    var base = "Medium"
    var topText = ""
    var customDataModel : [CustomPizzaModel] = [CustomPizzaModel]()
    
    var didAdd3dobject = false
    var objectrootPoint : SCNVector3?
    
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
        
        topingsCollectionView.reloadData()
        let firstIndexPath = IndexPath(item: 0, section: 0)
        topingsCollectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        dataPopulate()
        
        blurTopView.layer.cornerRadius = 14
        blurTopView.addBlurToView()
        baclofBlurView.addGradient([UIColor.black, UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.00)], locations: [0.0, 1.0],frame: baclofBlurView.frame)
        priceView.layer.cornerRadius = 6
        
        sidebar.layer.masksToBounds = true
        sidebar.addblurlight()
        plusButton.layer.cornerRadius = 12
        minusbutton.layer.cornerRadius = 12
        
        sideOptions.isHidden = true
        topContentView.isHidden = true
        addLighting()
        
        topText = "Pizza Size \(toppingsSize[topingDefault])"
        topTextLabel.text = topText
    }
    
    // Function to add lighting to the scene
    private func addLighting() {
        // Create an ambient light source
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 500
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight

        // Create a directional light source
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.intensity = 1000
        directionalLight.castsShadow = true
        let directionalLightNode = SCNNode()
        directionalLightNode.light = directionalLight
        directionalLightNode.position = SCNVector3(x: 0, y: 10, z: 0)

        // Add lights to the scene
        sceneView.scene.rootNode.addChildNode(ambientLightNode)
        sceneView.scene.rootNode.addChildNode(directionalLightNode)
    }
    
    @IBAction func sideOptionsClick(_ sender: UIButton) {
        if sender == plusButton {
            if topingDefault < toppingsSize.count-1 {
                topingDefault += 1
            }
        }
        if sender == minusbutton {
            if cellSellection != 0{
                if topingDefault > 0{
                    topingDefault -= 1
                }
            }else{
                if topingDefault > 1{
                    topingDefault -= 1
                }
            }
        }
        
        sideLabel.text = toppingsSize[topingDefault]
        dataPopulate()
    }
    
    private func dataPopulate(){
        
        var shouldAdd = true
        var tempIndex = 0
        for x in customDataModel{
            if topingNames[cellSellection] == x.Name {
                shouldAdd = false
                break
            }
            tempIndex += 1
        }
        
        if shouldAdd{
            let tempModel = CustomPizzaModel(Name: topingNames[cellSellection], Quantity: toppingsSize[topingDefault], didtouched: true)
            customDataModel.append(tempModel)
        }
        else{
            let tempModel = CustomPizzaModel(Name: topingNames[cellSellection], Quantity: toppingsSize[topingDefault], didtouched: true)
            customDataModel[tempIndex] = tempModel
        }
        
        
        var tempText = "Pizza "
        var isfirst = true
        for x in customDataModel{
            if x.Quantity != "None" {
                if isfirst {
                    base = x.Quantity
                    tempText += "\(x.Name) \(x.Quantity) with   "
                }
                else{
                    tempText = String(tempText.dropLast(2))
                    tempText += "\(x.Name) \(x.Quantity),   "
                }
            }
            isfirst = false
        }
        topTextLabel.text = String(tempText.dropLast(3))
        updateAr()
    }
    
    func updateAr(){
        
        var url = URL(string: "")
        
        if let ObjectRootPoint = objectrootPoint {
            var newPosistion = ObjectRootPoint
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                  if node.name == topingNames[cellSellection] {
                      node.removeFromParentNode()
                  }
              }
            
            switch topingNames[cellSellection] {
                case "Size":
                    if topingDefault == 1 {
                        url = Bundle.main.url(forResource: "pizzasmall", withExtension: "usdz")
                    }
                    else if topingDefault == 2{
                        url = Bundle.main.url(forResource: "pizzamedium", withExtension: "usdz")
                    }
                    else if topingDefault == 3 {
                        url = Bundle.main.url(forResource: "pizzaLarge", withExtension: "usdz")
                    }
                    break
                case "Cheddar":
                    if topingDefault == 1 {
                        url = Bundle.main.url(forResource: "cheeseSmall\(base)", withExtension: "usdz")
                        newPosistion.y -= 0.00009
                    }
                    else if topingDefault == 2{
                        url = Bundle.main.url(forResource: "cheeseSmall\(base)", withExtension: "usdz")
                        
                    }
                    else if topingDefault == 3 {
                        url = Bundle.main.url(forResource: "cheeseSmall\(base)", withExtension: "usdz")
                        newPosistion.y += 0.00005
                    }
                    break
                
                default:
                url = URL(string: "")
            }
            
            if let urlData = url{
                let scene = try? SCNScene(url: urlData)
                let newObject = scene!.rootNode.childNodes.first
                newObject?.position = newPosistion
                newObject?.name = topingNames[cellSellection]
                
                if let NewObject = newObject{
                    sceneView.scene.rootNode.addChildNode(NewObject)
                }
            }
        }
    
        
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
        if !didAdd3dobject {
            guard let touch = touches.first, let result = sceneView.hitTest(touch.location(in: sceneView), types: [.existingPlaneUsingExtent]).first else { return }

            let position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
            objectrootPoint = position
            let objectNode = createYour3DObject() // Create your 3D object node here
            
            objectNode.position = position
            objectNode.name = topingNames[cellSellection]
            sceneView.scene.rootNode.addChildNode(objectNode)
            
            DispatchQueue.main.async {
                self.topingsCollectionView.isHidden = false
                self.topContentView.isHidden = false
                self.sideOptions.isHidden = false
            }
            
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                  if node.name == "planeNode" {
                      node.removeFromParentNode()
                  }
              }
            
            didAdd3dobject = true
        }
        
    }
    
    private func createYour3DObject() -> SCNNode {
        // Load the USDZ model
        let url = Bundle.main.url(forResource: "pizzamedium", withExtension: "usdz")
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        topingDefault = 2
        
        if customDataModel.count > indexPath.row{
            if customDataModel[indexPath.row].didtouched {
                if let indexData = toppingsSize.firstIndex(where: { $0 ==  customDataModel[indexPath.row].Quantity}) {
                    topingDefault = indexData
                }
            }
        }
        
        sideLabel.text = toppingsSize[topingDefault]
        cellSellection = indexPath.row
        dataPopulate()
    }
}

class PizzaTopingsCustomCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var backOfLabel: UIView!
    @IBOutlet weak var backOfImage: UIView!
    @IBOutlet weak var contentViewBackground: UIView!
    @IBOutlet weak var topingsImage: UIImageView!
    @IBOutlet weak var topingsNameLabel: UILabel!
    override func awakeFromNib() {
//        contentViewBackground.layer.cornerRadius = 10
//        contentViewBackground.layer.borderWidth = 1
//        contentViewBackground.layer.borderColor = UIColor.orange.cgColor
        backOfImage.addblurlight()
        backOfLabel.addBlurToView(cornerRadious: 12)
        backOfImage.layer.cornerRadius = 14
        backOfLabel.layer.cornerRadius = 12
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backOfImage.layer.borderColor = UIColor.orange.cgColor
                backOfImage.layer.borderWidth = 1
                
                backOfLabel.layer.borderColor = UIColor.orange.cgColor
                backOfLabel.layer.borderWidth = 1
            } else {
                backOfImage.layer.borderColor = UIColor.clear.cgColor
                backOfImage.layer.borderWidth = 0
                
                backOfLabel.layer.borderColor = UIColor.clear.cgColor
                backOfLabel.layer.borderWidth = 0
            }
        }
    }
    
}

extension UIView {
    func addBlurToView(cornerRadious: CGFloat = 14) {
        var blurEffect: UIBlurEffect!
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: .dark)
        }else{
            blurEffect = UIBlurEffect(style: .light)
        }
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        blurredEffectView.alpha = 0.97
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredEffectView.layer.cornerRadius = cornerRadious
        blurredEffectView.layer.masksToBounds = true
        self.addSubview(blurredEffectView)
    }
    
    func addblurlight() {
        var blurEffect: UIBlurEffect!
        blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        blurredEffectView.alpha = 0.97
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredEffectView.layer.cornerRadius = 12
        blurredEffectView.layer.masksToBounds = true
        self.addSubview(blurredEffectView)
    }
    
   func addGradient(_ colors: [UIColor], locations: [NSNumber], frame: CGRect = .zero) {
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = colors.map{ $0.cgColor }
      gradientLayer.locations = locations
      gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
      gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
      gradientLayer.frame = frame
      layer.insertSublayer(gradientLayer, at: 0)
   }

    
}
