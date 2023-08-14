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

    @IBOutlet weak var topPriceLabel: UILabel!
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
    
    var basePrice = 21.99
    var totalPriceData = 0.00
    
    let topingNames = ["Size", "Cheddar", "Pepperoni", "Black_olives"]
    let toppingsSize = ["None", "Small", "Medium", "Large"]
    let priceData = [0.00, 2.99, 3.50, 4.50]
    
    var cellSellection = 0
    var topingDefault = 2
    
    var base = "Medium"
    var topText = ""
    var customDataModel : [CustomPizzaModel] = [CustomPizzaModel]()
    
    var didAdd3dobject = false
    var objectrootPoint : SCNVector3?
    
    var alreadyHaveAr = false
    var ArString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        topingsCollectionView.dataSource = self
        topingsCollectionView.delegate = self
        
        topingsCollectionView.register(UINib(nibName: "CustomOrdetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addtocartIdentifier")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        createAgain()
    }
    
    private func createAgain(){
        didAdd3dobject = false
        basePrice = 21.99
        totalPriceData = 0.00
        cellSellection = 0
        topingDefault = 2
        base = "Medium"
        topText = ""
        customDataModel.removeAll()
        
        objectrootPoint = nil
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        animation_lottie.isHidden = false
        animation_lottie.animation = LottieAnimation.named("move.json")
        animation_lottie.animationSpeed = 0.9
        animation_lottie.loopMode = .loop
        animation_lottie.play()
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

                sceneView.session.pause()
                sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                        node.removeFromParentNode()
            }

        }
    
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
    
    private func updateBasePrice(){
        var tempPrice = basePrice
        for xdata in customDataModel{
            if let indexData = toppingsSize.firstIndex(where: { $0 ==  xdata.Quantity}) {
                tempPrice += priceData[indexData]
            }
        }
        totalPriceData = tempPrice
        topPriceLabel.text = "$ "+String(format: "%.2f", tempPrice)
        
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
        updateBasePrice()
        topTextLabel.text = String(tempText.dropLast(3))
        
        updateAr()
    }
    
    func reselctToppings(){
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if topingNames.contains(node.name ?? "blah balh") {
                  node.removeFromParentNode()
              }
          }
        var url = URL(string: "")
        
        if let ObjectRootPoint = objectrootPoint {
            var newPosistion = ObjectRootPoint
            
            for xToppings in customDataModel{
                sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == xToppings.Name && node.name != topingNames[0] {
                        node.removeFromParentNode()
                    }
                }
                let qual = xToppings.Quantity
                
                switch xToppings.Name {
                    case "Size":
                        if topingDefault == 1 {
                            url = Bundle.main.url(forResource: "pizzasmall", withExtension: "usdz")
                            print(1)
                        }
                        else if topingDefault == 2{
                            url = Bundle.main.url(forResource: "pizzamedium", withExtension: "usdz")
                            print(2)
                        }
                        else if topingDefault == 3 {
                            url = Bundle.main.url(forResource: "pizzaLarge", withExtension: "usdz")
                            print(3)
                        }
                        break
                    case "Cheddar":
                        if qual == toppingsSize[1] {
                            url = Bundle.main.url(forResource: "cheeseSmall\(base)", withExtension: "usdz")
                            newPosistion.y -= 0.00009
                        }
                        else if qual == toppingsSize[2]{
                            url = Bundle.main.url(forResource: "cheeseSmall\(base)", withExtension: "usdz")
                            
                        }
                        else if qual == toppingsSize[3] {
                            url = Bundle.main.url(forResource: "cheeseSmall\(base)", withExtension: "usdz")
                            newPosistion.y += 0.00005
                        }
                        break
                    case "Pepperoni":
                        if qual == toppingsSize[1] {
                            url = Bundle.main.url(forResource: "PepperoniSmall\(base)", withExtension: "usdz")
                        }
                        else if qual == toppingsSize[2]{
                            url = Bundle.main.url(forResource: "PepperoniMedium\(base)", withExtension: "usdz")
                        }
                        else if qual == toppingsSize[3] {
                            url = Bundle.main.url(forResource: "PepperoniLarge\(base)", withExtension: "usdz")
                        }
                        break
                        
                    case "Black_olives":
                        if qual == toppingsSize[1] {
                            url = Bundle.main.url(forResource: "blackolivesSmall\(base)", withExtension: "usdz")
                        }
                        else if qual == toppingsSize[2]{
                            url = Bundle.main.url(forResource: "blackolivesMedium\(base)", withExtension: "usdz")
                            
                        }
                        else if qual == toppingsSize[3] {
                            url = Bundle.main.url(forResource: "blackolivesLarge\(base)", withExtension: "usdz")
                        }
                        break
                        
                        default:
                        url = URL(string: "")
                }
                
                
                if let urlData = url{
                    let scene = try? SCNScene(url: urlData)
                    let newObject = scene!.rootNode.childNodes.first
                    newObject?.position = newPosistion
                    newObject?.name = xToppings.Name
                    
                    if let NewObject = newObject{
                        sceneView.scene.rootNode.addChildNode(NewObject)
                    }
                }
                
            }
            
            
        }
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
                    reselctToppings()
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
                case "Pepperoni":
                    if topingDefault == 1 {
                        url = Bundle.main.url(forResource: "PepperoniSmall\(base)", withExtension: "usdz")
                    }
                    else if topingDefault == 2{
                        url = Bundle.main.url(forResource: "PepperoniMedium\(base)", withExtension: "usdz")
                        
                    }
                    else if topingDefault == 3 {
                        url = Bundle.main.url(forResource: "PepperoniLarge\(base)", withExtension: "usdz")
                    }
                    break
                    
                case "Black_olives":
                    if topingDefault == 1 {
                        url = Bundle.main.url(forResource: "blackolivesSmall\(base)", withExtension: "usdz")
                    }
                    else if topingDefault == 2{
                        url = Bundle.main.url(forResource: "blackolivesMedium\(base)", withExtension: "usdz")
                        
                    }
                    else if topingDefault == 3 {
                        url = Bundle.main.url(forResource: "blackolivesLarge\(base)", withExtension: "usdz")
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
        if let _ = objectrootPoint {
            print("comming here ")
        }else{
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

            let planeNode = createPlaneNode(anchor: planeAnchor)
            node.addChildNode(planeNode)
            
            DispatchQueue.main.async {
                self.animation_lottie.stop()
                self.animation_lottie.isHidden = true
            }
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
            let objectNode = createYour3DObject()
            
            objectNode.position = position
            objectNode.name = topingNames[cellSellection]
            sceneView.scene.rootNode.addChildNode(objectNode)
            
            DispatchQueue.main.async {
                if !self.alreadyHaveAr {
                    self.topingsCollectionView.isHidden = false
                    self.topContentView.isHidden = false
                    self.sideOptions.isHidden = false
                }
            }
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                  if node.name == "planeNode" {
                      node.removeFromParentNode()
                  }
              }
            
            reselctToppings()
            didAdd3dobject = true
     
        }
        
    }
    
    private func createYour3DObject() -> SCNNode {
        // Load the USDZ model
        var url = Bundle.main.url(forResource: "pizzamedium", withExtension: "usdz")
        if alreadyHaveAr{
            url = Bundle.main.url(forResource: "title1", withExtension: "usdz")
            if ArString.count > 0 {
                customDataModel.removeAll()
                print(ArString)
                let inputString = ArString
                var components = inputString.components(separatedBy: "with")
                
                let firstTEmoinputString = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let firstsize = firstTEmoinputString.components(separatedBy: " ")
                let firstsizeString = firstsize.last!
                
                if firstsizeString == "Small" {
                    url = Bundle.main.url(forResource: "pizzasmall", withExtension: "usdz")
                    topingDefault = 1
                    base = "Small"
                    customDataModel.append(CustomPizzaModel(Name: "Size", Quantity: "Small", didtouched: true))
                }
                else if firstsizeString == "Medium" {
                    url = Bundle.main.url(forResource: "pizzamedium", withExtension: "usdz")
                    topingDefault = 2
                    base = "Medium"
                    customDataModel.append(CustomPizzaModel(Name: "Size", Quantity: "Medium", didtouched: true))
                }
                else if firstsizeString == "Large" {
                    url = Bundle.main.url(forResource: "pizzaLarge", withExtension: "usdz")
                    topingDefault = 3
                    base = "Large"
                    customDataModel.append(CustomPizzaModel(Name: "Size", Quantity: "Large", didtouched: true))
                }
                
                print("size \(firstsizeString)")
                components.remove(at: 0)
                let tempStrig = components[0]
                components = tempStrig.components(separatedBy: ",")
                
                print(components)
                
                for x in components{
                    if x.count > 0 {
                        let wholeToppings = x.trimmingCharacters(in: .whitespacesAndNewlines)
                        let wholeToppingComp = wholeToppings.components(separatedBy: " ")
                        let firstPart = wholeToppingComp[0]
                        var secondPart = wholeToppingComp[1]
                        
                        if secondPart.hasSuffix(",") {
                            secondPart = String(secondPart.dropLast())
                        }
                        
                        customDataModel.append(CustomPizzaModel(Name: firstPart, Quantity: secondPart, didtouched: true))

                    }
                }
                print(customDataModel)
                
            }
        }
        let scene = try? SCNScene(url: url!)
        let objectNode = scene!.rootNode.childNodes.first
        return objectNode!
        
    }
}

extension BuildOwnViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topingNames.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < topingNames.count {
            let cell = topingsCollectionView.dequeueReusableCell(withReuseIdentifier: "topingsCellIdentifier", for: indexPath) as! PizzaTopingsCustomCollectionViewCell
            cell.topingsNameLabel.text = topingNames[indexPath.row]
            cell.topingsImage.image = UIImage(named: topingNames[indexPath.row])
            return cell
        }
        else{
            let cell = topingsCollectionView.dequeueReusableCell(withReuseIdentifier: "addtocartIdentifier", for: indexPath) as! CustomOrdetCollectionViewCell
            return cell
        }
  
    }

}

extension BuildOwnViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        if indexPath.row < topingNames.count {
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
        else{
            print(customDataModel)
            
            if let image = UIImage(named: "customPizza") {
                if let imageData = image.pngData(){
                    var CustomOrder = allMenu(menu_id: -1000001, menu_Time: "20", menu_Cat: "Custom", menu_Price: String(format: "%.2f", totalPriceData), menu_Name: "Custom Pizza", menu_Dec: topTextLabel.text ?? "pizzaDiscription", avg_Rating: "0.00", total_Ratings: "0.00", menu_photo_Data : imageData,menu_quantity:1, ratings: [Ratings(comment: "", rating: "")])
                    didAddNewItem = true
                    CartOrders?.append(CustomOrder)
                    print(CartOrders)
                    saveFetchCartData(fetchData: false)
                    tabBarController?.selectedIndex = 0
                }
            }
        }
            
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
