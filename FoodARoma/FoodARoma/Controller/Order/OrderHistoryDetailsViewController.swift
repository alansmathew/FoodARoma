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
        
        contentHeight = orderHistioryDetailsTable.frame.height
    }

    func setupUIDEtails(){
        
        if let outputDateString = Date().convertTo12HourFormat(dateString: ActiveOrderData!.pickup_time) {
            timeofOfPicup.text = "Time of Pickup : " + outputDateString
        } else {
            print("Invalid date string")
        }
        pageTitle.text = "Active Order #12000\(ActiveOrderData!.OrderId)"
        
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
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        updateUI()
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
        }
        else if sender.titleLabel?.text == "Accept Order"{
            UpdateOrderStatus(status: "Accepted")
        }
        else if sender.titleLabel?.text == "Ready for Pick Up"{
            UpdateOrderStatus(status: "Ready")
        }
        else if sender.titleLabel?.text == "Complete Order"{
            UpdateOrderStatus(status: "Completed")
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
