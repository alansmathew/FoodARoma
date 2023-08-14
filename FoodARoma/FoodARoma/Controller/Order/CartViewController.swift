//
//  CartViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-29.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import PanModal

class CartViewController: UIViewController {

    @IBOutlet weak var paymentMethodView: PaddedTextField!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var pickuptime: UIDatePicker!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var taxlabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var tableheight: NSLayoutConstraint!
    
    var totalprice = 0.00
    var contentHeight = 140.0
    private var loading : (NVActivityIndicatorView,UIView)?
    
    let pickerView = UIPickerView()
    let paymentMethods = ["Pay at Pick Up", "Debit / credit"]
    var selectedPaymentMethod: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        cartTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderHistoryIdentifier")
        cartTableView.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyCellIdentifier")
        
        if CartOrders?.count ?? 0 > 0 {
            bottomView.isHidden = false
            timeView.isHidden = false
        }
        else{
            bottomView.isHidden = true
            timeView.isHidden = true
        }
        contentHeight = cartTableView.frame.height
        navigationController?.navigationBar.isHidden = false
    
               
       // Assign the data source and delegate of the UIPickerView
        pickerView.dataSource = self
        pickerView.delegate = self
        paymentMethodView.text = paymentMethods[0]
        paymentMethodView.tintColor = UIColor.clear
        
        paymentMethodView.inputView = pickerView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(CartOrders)
        if goingtoPay{
            goingtoPay = false
            self.navigationController?.popViewController(animated: true)
        }
        pickuptime.minimumDate = Date.now
        pickuptime.date = Date.now
    }
    
    func totalData(price : Double){
        priceLabel.text = "$ " + String(format: "%.2f", totalprice)
        taxlabel.text = "$ " + String(format: "%.2f", totalprice * 0.13)
        totalLabel.text = "$ " + String(format: "%.2f", totalprice * 1.13)
    }
    
    func showDeleteWarning(for indexPath: IndexPath) {

        let alert = UIAlertController(title: "Delete cart item ?", message: "Are you sure that you wnat to delete this item from cart.", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                let price = Double(CartOrders![indexPath.row].menu_Price) ?? 0.00
                let qun =  Double(CartOrders![indexPath.row].menu_quantity!)
                let temp = price * qun
                self.totalprice -= temp
                self.totalData(price: self.totalprice)
                CartOrders?.remove(at: indexPath.row)
                saveFetchCartData(fetchData:false)
                if CartOrders?.count ?? 0 > 0 {
                    self.cartTableView.deleteRows(at: [indexPath], with: .fade)
                    let caritems = CartOrders?.count ?? 1
                    if  self.contentHeight > Double(caritems * 140) {
                        self.tableheight.constant = self.contentHeight
                    }
                    else{
                        self.tableheight.constant = Double(caritems * 140)
                    }
                    
                }
                else{
                    self.timeView.isHidden = true
                    self.bottomView.isHidden = true
                    self.totalprice = 0.00
                    self.cartTableView.reloadData()
                }
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.success)
            }
        }

        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        //Present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func confirmOrderClick(_ sender: Any) {
        


        if let userType = UserDefaults.standard.string(forKey: "USERTYPE"){
            let nameData =  UserDefaults.standard.string(forKey: "NAME")
            let userId = UserDefaults.standard.string(forKey: "USERID")
            if let id = userId, let name = nameData{

                if let aOrder = ActiveOrders {
                    showAlert(title: "Order Already exist", content: "An orde already exist, so you wont be able to make this order at this time, please make sure that you complete the current order and come back again.")
                }
                else{
                    var ordersDataTemp : [OrderData]? = [OrderData]()
                    if let orders = CartOrders {
                        for x in orders{
                            if x.menu_id == -1000001{
                                ordersDataTemp?.append(OrderData(order_type: x.menu_Cat, order_dis: x.menu_Dec, order_no: x.menu_id, order_qty: x.menu_quantity!))
                            }
                            else{
                                ordersDataTemp?.append(OrderData(order_type: x.menu_Cat, order_dis: x.menu_Dec, order_no: x.menu_id, order_qty: x.menu_quantity!))
                            }
                        }
                        
                        
                        // Convert the array of OrderData to an array of dictionaries
                        var ordersArray: [[String: Any]] = []
                        for orderData in ordersDataTemp! {
                            let orderDict: [String: Any] = [
                                "order_type": orderData.order_type,
                                "order_dis": orderData.order_dis,
                                "order_no": orderData.order_no,
                                "order_qty": orderData.order_qty
                            ]
                            ordersArray.append(orderDict)
                        }
                        
                        let params: [String: Any] = [
                            "Mode": "AddOrder",
                            "Orders": ordersArray,
                            "special_note": "dfgh",
                            "is_accepted": "not_accepted",
                            "user_id": id,
                            "user_name": name,
                            "pref_time" : "\(pickuptime.date)",
                            "transaction_id" : "",
                            "total_price": String(format: "%.2f", totalprice * 1.13)
                        ]
                        
                        print(params)
                        
                        
                        if paymentMethodView.text == "Debit / credit"{
                            let storyboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
                            let viewC = storyboard.instantiateViewController(withIdentifier: "paymentViewController") as! paymentViewController
                            viewC.parms = params
                            viewC.price = totalprice
                            self.presentPanModal(viewC)
                            
                        }else{
                            
                            do {
                                loading = customAnimation()
                                loadingProtocol(with: loading! ,true)
                                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                                if let jsonString = String(data: jsonData, encoding: .utf8) {
                                    print(jsonString)
                                }
                                print(Constants().BASEURL + Constants.APIPaths().AddOrder)
                                AF.request(Constants().BASEURL + Constants.APIPaths().AddOrder, method: .post, parameters: params, encoding: JSONEncoding.default).responseData {
                                    (response) in
                                    
                                    self.loadingProtocol(with: self.loading! ,false)
                                    
                                    switch (response.result) {
                                    case .success:
                                        if (JSON(response.data)["Message"]=="success"){
                                            let orderID = Int("\(JSON(response.data)["OrderId"])")
                                            if let orderid = orderID{
                                                ActiveOrders = ActiveOrderModel(OrderId: orderid, pickup_time: "\(self.pickuptime.date)", is_accepted: "Not Accepted", CartOrders: CartOrders!)
                                                print(ActiveOrders)
                                                CartOrders?.removeAll()
                                                
                                                self.timeView.isHidden = true
                                                self.bottomView.isHidden = true
                                                self.totalprice = 0.00
                                                saveFetchCartData(fetchData: false)
                                                updateActiveOrderStatus()
                                                self.cartTableView.reloadData()
                                                let feedbackGenerator = UINotificationFeedbackGenerator()
                                                feedbackGenerator.notificationOccurred(.success)
                                                
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                            else{
                                                self.showAlert(title: "Something went wrong!", content: "unfotunatly there was something wrong with the request. please try again later.")
                                                print("error in orderid or array")
                                                let feedbackGenerator = UINotificationFeedbackGenerator()
                                                feedbackGenerator.notificationOccurred(.error)
                                                
                                            }
                                            
                                        }
                                        else{
                                            self.showAlert(title: "Something went wrong!", content: "unfotunatly there was something wrong with the request. please try again later.")
                                            print(JSON(response.data!))
                                        }
                                        //                                print(JSON(response.data!))
                                        
                                    case .failure(let error):
                                        print("error --> \(error)")
                                    }
                                }
                                
                            } catch {
                                print("Error converting params to JSON: \(error)")
                                self.loadingProtocol(with: self.loading! ,false)
                            }
                        }
                        
                        
                    }
                }

            }

        }
        else{
            showAlert(title: "No User found", content: "In order to make a purchase, please make sure that you hava an accound and it is currently logged in !")
            loadingProtocol(with: loading! ,false)
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

extension CartViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if CartOrders?.count ?? 0 > 0{
            let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                 DispatchQueue.main.async {
                     let feedbackGenerator = UINotificationFeedbackGenerator()
                     feedbackGenerator.notificationOccurred(.warning)
                     self.showDeleteWarning(for: indexPath)
                 }
                 success(true)
             })

             modifyAction.image = UIImage(named: "delete")
             modifyAction.backgroundColor = .red

             return UISwipeActionsConfiguration(actions: [modifyAction])
        }
        else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        viewC.SelectedOrder = CartOrders![indexPath.row]
        navigationController?.pushViewController(viewC, animated: true)
    }
}


extension CartViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Int(CartOrders?.count ?? 0) == 0 {
            tableheight.constant = 140
            return 1
        }else{
            let caritems = CartOrders?.count ?? 1
            if  caritems * 140 > Int(tableView.frame.height) {
                tableheight.constant = Double(caritems * 140)
            }
            return Int(CartOrders?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let orders = CartOrders, orders.count > 0{
            let cell = cartTableView.dequeueReusableCell(withIdentifier: "orderHistoryIdentifier", for: indexPath) as! OrderTableViewCell
            if let menuPhotoData = orders[indexPath.row].menu_photo_Data {
                cell.orderimageView.image = UIImage(data: menuPhotoData, scale:1)
            }
            else{
                loadImageInCell(cellData: cell, cellImageName: orders[indexPath.row].menu_Photo)
            }
                
            cell.orderName.text = orders[indexPath.row].menu_Name
            cell.orderPrice.text = "$ " + orders[indexPath.row].menu_Price
            cell.orderQ.text = "Quantity : \(orders[indexPath.row].menu_quantity!)"
            let price = Double(orders[indexPath.row].menu_Price) ?? 0.00
            let qun =  Double(orders[indexPath.row].menu_quantity ?? 1)
            totalprice += price * qun
            totalData(price: totalprice)
                
            return cell
        }
        else{
            let cell = cartTableView.dequeueReusableCell(withIdentifier: "emptyCellIdentifier", for: indexPath) as! EmptyTableViewCell
            return cell
        }
        
    }
    
}
extension CartViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // We are using a single component in the picker view
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paymentMethods.count // Return the number of categories
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentMethods[row] // Return the category name for each row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = paymentMethods[row]
        paymentMethodView.text = selectedCategory // Set the selected category in the text field
    }

}

struct OrderData : Codable{
    let order_type,order_dis : String
    let order_no, order_qty : Int
}
