//
//  HomeViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-04.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var roundedcartButton: UIView!
    @IBOutlet weak var specialCollectionVew: UICollectionView!
    @IBOutlet weak var regularMenuCollectionVew: UICollectionView!
    @IBOutlet weak var BeverageCollctionView: UICollectionView!
    
    private var loading : (NVActivityIndicatorView,UIView)?
    let locationManager = CLLocationManager()
    let animationDuration: TimeInterval = 0.93
    let messageLabel = UILabel()
    let tickImageView = UIImageView(image: UIImage(systemName: "checkmark.seal"))

    
    private var AllMenuItems : AllMenuModel?
    private var specialMenu : [allMenu]? = [allMenu]()
    private var regMenu : [allMenu]? = [allMenu]()
    private var bevMenu : [allMenu]? = [allMenu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.hideKeyboardWhenTappedAround()

        specialCollectionVew.delegate = self
        specialCollectionVew.dataSource = self
        regularMenuCollectionVew.dataSource = self
        regularMenuCollectionVew.delegate = self
        BeverageCollctionView.dataSource = self
        BeverageCollctionView.delegate = self
        roundedcartButton.alpha = 0.0
        
        specialCollectionVew.register(UINib(nibName: "HomeMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeMenuCelliIdentifier")
        regularMenuCollectionVew.register(UINib(nibName: "HomeMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeMenuCelliIdentifier")
        BeverageCollctionView.register(UINib(nibName: "BeverageMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBeverageIdentifier")
        
        setupCartAnimation()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        roundedcartButton.layer.cornerRadius = roundedcartButton.frame.width / 2
        
        if CartOrders?.count ?? 0 > 0 {
            roundedcartButton.alpha = 1
        }
        else{
            roundedcartButton.alpha = 0.0
        }
    }

    override func viewDidLayoutSubviews() {
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
        fetchAllMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if didAddNewItem{
            UIView.animate(withDuration: animationDuration, animations: {
                self.messageLabel.center = self.view.center
                self.messageLabel.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: self.animationDuration/3, animations: {
                    self.tickImageView.alpha = 1.0
                }) { _ in

                    UIView.animate(withDuration: self.animationDuration*2/3, delay: self.animationDuration/3, animations: {
                        self.messageLabel.center = CGPoint(x: self.view.bounds.width - self.messageLabel.bounds.width/2 - 20,
                                                            y: self.view.safeAreaInsets.top + self.messageLabel.bounds.height/2 + 20)
                        self.messageLabel.alpha = 0.0
                        self.tickImageView.alpha = 0.0
                        didAddNewItem = !didAddNewItem
                    })
                }
            }
        }
        if !arrivaldismissed {
            checkAvtiveOrderArrival()
        }
    }
    
    private func checkAvtiveOrderArrival(){
        if let userType = UserDefaults.standard.string(forKey: "USERTYPE"){
            if userType == "customer"{
//                home
//                let latitude = 43.47653453726806
//                let longitude = -80.53817017597704
                
                // collage
//                let latitude = 43.48054744327771
//                let longitude = -80.51884224725556
                
//                let targetLatitude = 37.7755
//                let targetLongitude = -122.4190
                
                getCurrentLocation { coordinate in
                    if let coordinate = coordinate {
                        let distanceThreshold: CLLocationDistance = 100.0
                        
                        let isWithinDistance = isLocationWithinDistance(latitude: llatitude, longitude: llongitude, targetLocation: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), distance: distanceThreshold)

                        if isWithinDistance {
                            if let activeOrder = ActiveOrders {
                                if activeOrder.is_accepted != "not_accepted"{
                                    print("present view")
                                    let storyboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
                                    let viewC = storyboard.instantiateViewController(withIdentifier: "ArrivalViewController") as! ArrivalViewController
//                                    viewC.parms = params
//                                    viewC.price = totalprice
                                    self.presentPanModal(viewC)
                                }
                            }
                            print("Location is within 100 meters.")
                        } else {
                            print("Location is more than 100 meters away.")
                        }
                    } else {
                        print("Unable to retrieve current location.")
                    }
                }
       
            }
        }
    }
    
    func setupCartAnimation(){
        // Set up the label
        messageLabel.text = "Added to cart"
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize:19)
        messageLabel.textColor = .white
        messageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        messageLabel.layer.cornerRadius = 10
        messageLabel.clipsToBounds = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.alpha = 0.0

        view.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(equalToConstant: 200),
            messageLabel.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Place the label initially outside the screen on the top center
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: -25).isActive = true

        // Set up the tick mark image view
        tickImageView.alpha = 0.0
        tickImageView.contentMode = .scaleAspectFit
        tickImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tickImageView)

        NSLayoutConstraint.activate([
            tickImageView.widthAnchor.constraint(equalToConstant: 30),
            tickImageView.heightAnchor.constraint(equalToConstant: 30),
            tickImageView.centerXAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 15),
            tickImageView.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor)
        ])
    }

    func populateCollectionViews(){
        if let allmenuitems = AllMenuItems {
            for x in allmenuitems.AllMenu{
                if (x.menu_Cat == "special"){
                    specialMenu?.append(x)
                }
                else if (x.menu_Cat == "menu"){
                    regMenu?.append(x)
                }
                else if (x.menu_Cat == "beverage"){
                    bevMenu?.append(x)
                }
            }
            bevMenuGlobal = bevMenu
            specialCollectionVew.reloadData()
            regularMenuCollectionVew.reloadData()
            BeverageCollctionView.reloadData()
        }
    }
    
    @IBAction func searchclick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        viewC.AllMenuData = AllMenuItems?.AllMenu
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func cartButtonClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    func fetchAllMenu(){
        if let allmenuitem = AllMenuItems {
            self.loadingProtocol(with: self.loading! ,false)
        }
        else{
            
            let params : [String : String] = [
                    "Mode" : "fetchMenu"
                ]
            
            AF.request((Constants().BASEURL + Constants.APIPaths().fetchMenu), method: .post, parameters:params, encoder: .json).responseData { response in
                switch response.result{
                case .success(let data):
//                                    print(JSON(data))
                    let decoder = JSONDecoder()
                    do{
                        let jsonData = try decoder.decode(AllMenuModel.self, from: data)
                        self.AllMenuItems = jsonData
                        AllMenuDatas = jsonData
                        self.populateCollectionViews()
                        self.loadingProtocol(with: self.loading! ,false)
                        
                    }
                    catch{
                        print(response.result)
                        self.loadingProtocol(with: self.loading! ,false)
                        print("decoder error")
                    }
                    
                case .failure(let error):
                    self.loadingProtocol(with: self.loading! ,false)
                    self.showAlert(title: "network intrepsion", content: "Something went wrong! please try again after some time")
                    print(error)
                }
            }
        }
    }
    
    func loadImageInCell(cellData : HomeMenuCollectionViewCell, cellImageName : String?, indexOfloading : Int, model : String){
        if let imageName = cellImageName {
            AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

             switch response.result {
              case .success(let responseData):
                
                 if (JSON(responseData)["message"]=="Internal server error"){
                     print("NO data comming")
                     cellData.menuImageView.image = UIImage(named: "imagebackground")
                     
                 }
                 else{
                     cellData.menuImageView.image = UIImage(data: responseData!, scale:1)
                     if model == "Special"{
                         self.specialMenu?[indexOfloading].addImgeData(imageData: responseData!)
                     }
                     else if model == "Menu"{
                         self.regMenu?[indexOfloading].addImgeData(imageData: responseData!)
//                         print(self.regMenu?[indexOfloading].menu_photo_Data)
                     }
                     else if model == "bev"{
                         self.bevMenu?[indexOfloading].addImgeData(imageData: responseData!)
                     }
                 }
              case .failure(let error):
                  print("error--->",error)
              }
          }
        }
    }
    
    func loadImageInCellbev(cellData : BeverageMenuCollectionViewCell, cellImageName : String?, indexOfloading : Int){
        if let imageName = cellImageName {
            AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

             switch response.result {
              case .success(let responseData):
                
                 if (JSON(responseData)["message"]=="Internal server error"){
                     print("NO data comming")
                     cellData.bevImageVew.image = UIImage(named: "imagebackground")
                     
                 }
                 else{
                    cellData.bevImageVew.image = UIImage(data: responseData!, scale:1)
                    self.bevMenu?[indexOfloading].addImgeData(imageData: responseData!)
                 }
              case .failure(let error):
                  print("error--->",error)
              }
          }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
        }
    
    @IBAction func specialMenuAllClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        viewC.commingPlatform = "Special Menus"
        viewC.AllMenuData = specialMenu
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func regMenuAllClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        viewC.AllMenuData = regMenu
        viewC.commingPlatform = "Menu"
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func bevAllClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        viewC.commingPlatform = "Beverages"
        viewC.AllMenuData = bevMenu
        navigationController?.pushViewController(viewC, animated: true)
    }

}

extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case specialCollectionVew:
            return specialMenu?.count ?? 0
        case regularMenuCollectionVew:
            return regMenu?.count ?? 0
        case BeverageCollctionView:
            return bevMenu?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        switch collectionView {
            case specialCollectionVew:
                let cell1 = specialCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
                if let specialmenuitem = specialMenu {
                    cell1.menuNameLabel.text = specialmenuitem[indexPath.row].menu_Name
                    cell1.priceLabel.text = "$ "+specialmenuitem[indexPath.row].menu_Price
                    cell1.ratingLabel.text = specialmenuitem[indexPath.row].avg_Rating == "None" ? "0" : specialmenuitem[indexPath.row].avg_Rating
                    cell1.timeLabel.text = specialmenuitem[indexPath.row].menu_Time + " Min"
                    cell1.descLabel.text = specialmenuitem[indexPath.row].menu_Dec
                    if let menuPhotoData = specialmenuitem[indexPath.row].menu_photo_Data {
                        cell1.menuImageView.image = UIImage(data: menuPhotoData, scale:1)
                    }
                    else{
                        loadImageInCell(cellData: cell1, cellImageName: specialmenuitem[indexPath.row].menu_Photo, indexOfloading: indexPath.row, model: "Special")
                    }
                }
                return cell1
                
            case regularMenuCollectionVew:
                let cell2 = regularMenuCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
                if let regularMenu = regMenu {
                    cell2.menuNameLabel.text = regularMenu[indexPath.row].menu_Name
                    cell2.priceLabel.text = "$ "+regularMenu[indexPath.row].menu_Price
                    cell2.ratingLabel.text = regularMenu[indexPath.row].avg_Rating == "None" ? "0" : regularMenu[indexPath.row].avg_Rating
                    cell2.timeLabel.text = regularMenu[indexPath.row].menu_Time + " Min"
                    cell2.descLabel.text = regularMenu[indexPath.row].menu_Dec
                    if let menuPhotoData = regularMenu[indexPath.row].menu_photo_Data {
                        cell2.menuImageView.image = UIImage(data: menuPhotoData, scale:1)
                    }
                    else{
                        loadImageInCell(cellData: cell2, cellImageName: regularMenu[indexPath.row].menu_Photo, indexOfloading: indexPath.row, model: "Menu")
                    }
                }
                return cell2
            
            case BeverageCollctionView:
                let cell3 = BeverageCollctionView.dequeueReusableCell(withReuseIdentifier: "HomeBeverageIdentifier", for: indexPath) as! BeverageMenuCollectionViewCell
            
                    if let bevmenu = bevMenu?[indexPath.row] {
                        if let menuPhotoData = bevmenu.menu_photo_Data {
                            cell3.bevImageVew.image = UIImage(data: menuPhotoData, scale:1)
                        }
                        else{
                            loadImageInCellbev(cellData: cell3, cellImageName: bevmenu.menu_Photo, indexOfloading: indexPath.row)
                        }
                        cell3.moneyLabel.text = "$ "+(bevmenu.menu_Price)
                    }
                return cell3
               
            
            default:
                cell = specialCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
        }
        
        return cell
    }
    
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case specialCollectionVew:
            let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            viewC.SelectedOrder = specialMenu![indexPath.row]
            navigationController?.pushViewController(viewC, animated: true)
            
        case BeverageCollctionView:
//            still have to work on this
            let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            viewC.SelectedOrder = bevMenu![indexPath.row]
            navigationController?.pushViewController(viewC, animated: true)
            
        default:
            let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            viewC.SelectedOrder = regMenu![indexPath.row]
            navigationController?.pushViewController(viewC, animated: true)
        }
    
        
    }
}

extension HomeViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("getiig location")
           guard let location = locations.last else { return }
           
        print(1)
           // Perform reverse geocoding to get address details
           let geocoder = CLGeocoder()
           geocoder.reverseGeocodeLocation(location) { placemarks, error in
               if let error = error {
                   print("Reverse geocoding error: \(error)")
                   return
               }
               
               if let placemark = placemarks?.first {
                   let city = placemark.locality ?? ""
                   let province = placemark.administrativeArea ?? ""
                   let country = placemark.country ?? ""
                   
                   // Update the label with the location information
                   let locationInfo = "\(city), \(province), \(country)"
                   self.locationLabel.text = locationInfo
               }
           }
           
           locationManager.stopUpdatingLocation()
       }
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let locationManager = CLLocationManager()
            
            // Check the authorization status
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined {
                // Request location authorization if not determined
                locationManager.requestWhenInUseAuthorization()
                return // Wait for the callback
            } else if status != .authorizedWhenInUse && status != .authorizedAlways {
                // Handle denied or restricted authorization
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
                if let location = locationManager.location {
                    DispatchQueue.main.async {
                        completion(location.coordinate)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }


}

