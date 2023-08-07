//
//  OrderHistoryDetailsViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-08-02.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrderHistoryDetailsViewController: UIViewController {

    @IBOutlet weak var detailsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var FinalButton: UIButton!
    @IBOutlet weak var timeofOfPicup: UILabel!
    @IBOutlet weak var acceptenceStausView: UIView!
    @IBOutlet weak var acceptenceLAbel: UILabel!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var orderHistioryDetailsTable: UITableView!
    
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
    
    @IBAction func BottomAcceptButtonClick(_ sender: UIButton) {
        if sender.titleLabel?.text == "Cancel order" {
            cancalOrder()
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
                cell.orderimageView.image = UIImage(data: orders[indexPath.row].menu_photo_Data!, scale:1)
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
