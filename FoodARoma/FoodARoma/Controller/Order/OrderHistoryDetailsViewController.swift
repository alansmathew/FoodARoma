//
//  OrderHistoryDetailsViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-08-02.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import MapKit
import CoreLocation

class OrderHistoryDetailsViewController: UIViewController {

    @IBOutlet weak var changetimeDate: UIDatePicker!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var detailsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var FinalButton: UIButton!
    @IBOutlet weak var timeofOfPicup: UILabel!
    @IBOutlet weak var acceptenceStausView: UIView!
    @IBOutlet weak var acceptenceLAbel: UILabel!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var orderHistioryDetailsTable: UITableView!
    
    
    private var loading : (NVActivityIndicatorView,UIView)?
    var ActiveOrderData : ActiveOrderModel?
    
    var totalprice = 0.00
    var contentHeight = 140.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptenceStausView.layer.cornerRadius = acceptenceStausView.frame.width/2
        orderHistioryDetailsTable.dataSource = self
        orderHistioryDetailsTable.delegate = self
        orderHistioryDetailsTable.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderHistoryIdentifier")
        setupUIDEtails()
        navigationController?.navigationBar.isHidden = false
        
        contentHeight = orderHistioryDetailsTable.frame.height
        arrivaldismissed = false
    }

    func setupUIDEtails(){
        
        if let outputDateString = Date().convertTo12HourFormat(dateString: ActiveOrderData!.pickup_time) {
            timeofOfPicup.text = "Time of Pickup : " + outputDateString
        } else {
            print("Invalid date string")
        }
        pageTitle.text = "Active Order #12000\(ActiveOrderData!.OrderId)"
        acceptenceLAbel.text = ActiveOrderData!.is_accepted
        
    }
    
    private func updateUI(){
        if let userType = UserDefaults.standard.string(forKey: "USERTYPE"){
            print(userType)
            if userType == "restaurant"{

                
                switch ActiveOrderData?.is_accepted {
                case "not_accepted":
                    FinalButton.setTitle("Accept Order", for: .normal)
                    FinalButton.setTitleColor(UIColor.white, for: .normal)
                    FinalButton.backgroundColor = UIColor(red: 0.17, green: 0.36, blue: 0.20, alpha: 0.45)
                    FinalButton.layer.cornerRadius = 10
                    FinalButton.layer.masksToBounds = true
                    
                    timeofOfPicup.text = "Time of Pickup : "
                    let dateString = ActiveOrderData!.pickup_time
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    if let date = dateFormatter.date(from: dateString) {
                        changetimeDate.date = date
//                        changetimeDate.minimumDate = Date.now
                    }
                    
                case "Accepted":
                    acceptenceStausView.backgroundColor = UIColor(red: 0.17, green: 0.36, blue: 0.20, alpha: 0.75)
                    FinalButton.setTitle("Ready for Pick Up", for: .normal)
                    FinalButton.setTitleColor(UIColor.white, for: .normal)
                    FinalButton.backgroundColor = UIColor(red: 0.17, green: 0.36, blue: 0.20, alpha: 0.75)
                    FinalButton.layer.cornerRadius = 10
                    FinalButton.layer.masksToBounds = true
                    acceptenceLAbel.text = "Accepted"
                    if let outputDateString = Date().convertTo12HourFormat(dateString: ActiveOrderData!.pickup_time) {
                        timeofOfPicup.text = "Time of Pickup : " + outputDateString
                    } else {
                        print("Invalid date string")
                    }
                    changetimeDate.isHidden = true
                    
                case "Ready":
                    acceptenceStausView.backgroundColor = UIColor(red: 0.17, green: 0.36, blue: 0.20, alpha: 1)
                    FinalButton.setTitle("Complete Order", for: .normal)
                    FinalButton.setTitleColor(UIColor.white, for: .normal)
                    FinalButton.backgroundColor = UIColor(red: 0.17, green: 0.36, blue: 0.20, alpha: 1)
                    FinalButton.layer.cornerRadius = 10
                    FinalButton.layer.masksToBounds = true
                    acceptenceLAbel.text = "Ready for pick up"
                    if let outputDateString = Date().convertTo12HourFormat(dateString: ActiveOrderData!.pickup_time) {
                        timeofOfPicup.text = "Time of Pickup : " + outputDateString
                    } else {
                        print("Invalid date string")
                    }
                    changetimeDate.isHidden = true
                    
                case "Completed":
                    navigationController?.popViewController(animated: true)
                
                   
                    
                default:
                    FinalButton.setTitle("Accept Order", for: .normal)
                    FinalButton.setTitleColor(UIColor.white, for: .normal)
                    FinalButton.backgroundColor = UIColor(named: "GreenColor")
                    FinalButton.layer.cornerRadius = 10
                    FinalButton.layer.masksToBounds = true
                    
                    timeofOfPicup.text = "Time of Pickup : "
                    let dateString = ActiveOrderData!.pickup_time
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    if let date = dateFormatter.date(from: dateString) {
                        changetimeDate.date = date
                    }
                }
                
                instructionLabel.text = "You will be able to change the time above to let user know which time will the prodicts be available. After accepting the order, you wont be able to do so."
                
            }
            else{
                changetimeDate.isHidden = true
                
                if ActiveOrderData?.is_accepted != "not_accepted"{
                    acceptenceStausView.backgroundColor = UIColor(red: 0.17, green: 0.36, blue: 0.20, alpha: 0.75)
                    FinalButton.setTitle("Navigate", for: .normal)
                    FinalButton.setTitleColor(UIColor.white, for: .normal)
                    FinalButton.backgroundColor = UIColor(red: 0.17, green: 0.36, blue: 0.20, alpha: 0.75)
                    FinalButton.layer.cornerRadius = 10
                    FinalButton.layer.masksToBounds = true
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        updateUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        updateOrderStatus()
        if !arrivaldismissed {
            checkAvtiveOrderArrival()
        }
    }
    
    private func checkAvtiveOrderArrival(){
        if let userType = UserDefaults.standard.string(forKey: "USERTYPE"){
            if userType == "customer"{
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
    
    private func updateOrderStatus() {
        loadingProtocol(with: loading! ,true)
        let params = [
            "Mode" : "fetchActiveStatus",
            "OrderId":"\(ActiveOrderData!.OrderId)"
        ]
        AF.request((Constants().BASEURL + Constants.APIPaths().AddOrder), method: .post, parameters:params, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
                print(JSON(data))
                let decoder = JSONDecoder()
                do{
                    
                    let jsonData = try decoder.decode(orderUpdatesModel.self, from: data)
                    self.acceptenceLAbel.text = jsonData.is_accepted
                
                    
//                    self.ResturentCurrentOrdersTable.reloadData()
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
    
    override func viewDidLayoutSubviews() {
        loading = customAnimation()
        loadingProtocol(with: loading! ,false)
    }
    
    func cancalOrder(){
        print("cancel Order Called")
        
        let alert = UIAlertController(title: "Cancel Order ?", message: "Are you sure that you want to cancel this order ? The special menu might be one in lifetime oppertunity to get enjoy, by clicking delete you opet out of this. ", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                if let activeOrder = self.ActiveOrderData {
                    let param = [
                        "Mode" : "DeleteOrder",
                        "OrderId": "\(activeOrder.OrderId)"
                    ]
                    
                    print(param)
                    print("url --->" + Constants().BASEURL + Constants.APIPaths().AddOrder)
                    
                    AF.request( Constants().BASEURL + Constants.APIPaths().AddOrder, method: .post, parameters: param, encoder: .json).response{
                        response in

                     switch response.result {
                      case .success(let responseData):
                         if JSON(responseData)["Message"] == "success"{
                             ActiveOrders = nil
                             updateActiveOrderStatus()
                             self.navigationController?.popViewController(animated: true)
                         }
                         else{
                             self.showAlert(title: "Something went wrong!", content: "unfotunatly there was something wrong with the request. please try again later.")
                             print(JSON(responseData))
                         }

                      case .failure(let error):
                          print("error--->",error)
                      }
                  }
                    
                }
            }
        }

        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        //Present the alert controller
        present(alert, animated: true, completion: nil)
        
    }
    
    func UpdateOrderStatus(status : String){
        loadingProtocol(with: loading! ,true)
        var datetime = ActiveOrderData!.pickup_time
        if status == "Accepted"{
            datetime = "\(changetimeDate.date)"
        }
        let param = [
            "Mode" : "UpdateOrder",
            "OrderId":"\(ActiveOrderData!.OrderId)",
            "is_accepted": status,
            "pickup_time" : datetime
        ]
        
        AF.request( Constants().BASEURL + Constants.APIPaths().AddOrder, method: .post, parameters: param, encoder: .json).response{
            response in

         switch response.result {
          case .success(let responseData):
             if JSON(responseData)["Message"] == "success"{
                 self.ActiveOrderData?.updateOrderStatusinModel(Status: status)
                 if status == "Accepted"{
                     self.ActiveOrderData?.updateOrderTime(TimeData: datetime)
                 }
                 self.updateUI()
                 self.loadingProtocol(with: self.loading! ,false)
             }
             else{
                 self.loadingProtocol(with: self.loading! ,false)
                 self.showAlert(title: "Something went wrong!", content: "unfotunatly there was something wrong with the request. please try again later.")
                 print(JSON(responseData))
             }

          case .failure(let error):
             self.loadingProtocol(with: self.loading! ,false)
              print("error--->",error)
        }
      }
    }
    
    @IBAction func BottomAcceptButtonClick(_ sender: UIButton) {
        if sender.titleLabel?.text == "Cancel order" {
            cancalOrder()
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.warning)
        }
        else if sender.titleLabel?.text == "Accept Order"{
            UpdateOrderStatus(status: "Accepted")
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.success)
        }
        else if sender.titleLabel?.text == "Ready for Pick Up"{
            UpdateOrderStatus(status: "Ready")
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.success)
        }
        else if sender.titleLabel?.text == "Complete Order"{
            UpdateOrderStatus(status: "Completed")
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.success)
        }
        else if sender.titleLabel?.text == "Navigate"
        {
            let latitude: Double = 43.479656572010285
            let longitude: Double = -80.48429532738243
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let placemark = MKPlacemark(coordinate: coordinate)

            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Lancaster Smoke House" // Set your destination name here
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
               let url = URL(string: "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving")!
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
               mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.success)
        }
    }
    
    private func loadImageInCell(cellData : OrderTableViewCell, cellImageName : String?){
        if let imageName = cellImageName {
            AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

             switch response.result {
              case .success(let responseData):
                
                 if (JSON(responseData)["message"]=="Internal server error"){
                     print("NO data comming")
                     cellData.orderimageView.image = UIImage(named: "imagebackground")
                 }
                 else{
                     cellData.orderimageView.image = UIImage(data: responseData!, scale:1)
                 }
              case .failure(let error):
                  print("error--->",error)
              }
          }
        }
    }

}

extension OrderHistoryDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let caritems = ActiveOrderData?.CartOrders.count ?? 1
        if  caritems * 140 > Int(tableView.frame.height) {
            detailsTableHeight.constant = Double(caritems * 140)
        }
        return Int(ActiveOrderData?.CartOrders.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let orders = ActiveOrderData?.CartOrders, orders.count > 0{
            let cell = orderHistioryDetailsTable.dequeueReusableCell(withIdentifier: "orderHistoryIdentifier", for: indexPath) as! OrderTableViewCell
            if let imageData = orders[indexPath.row].menu_photo_Data {
                cell.orderimageView.image = UIImage(data: imageData, scale:1)
            }
            else{
                loadImageInCell(cellData: cell, cellImageName: orders[indexPath.row].menu_Photo)
            }
                
                cell.orderName.text = orders[indexPath.row].menu_Name
                cell.orderPrice.text = "$ " + orders[indexPath.row].menu_Price
                cell.orderQ.text = "Quantity : \(orders[indexPath.row].menu_quantity!)"
//                let price = Double(orders[indexPath.row].menu_Price) ?? 0.00
//                let qun =  Double(orders[indexPath.row].menu_quantity ?? 1)
//                totalprice += price * qun
//                totalData(price: totalprice)
                
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    
}

extension OrderHistoryDetailsViewController : UITableViewDelegate {
    
}

extension OrderHistoryDetailsViewController : CLLocationManagerDelegate {
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

struct orderUpdatesModel : Codable {
    let date_time, is_accepted : String
}
