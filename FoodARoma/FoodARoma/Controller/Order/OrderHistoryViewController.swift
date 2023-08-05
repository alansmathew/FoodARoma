//
//  OrderHistoryViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-29.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrderHistoryViewController: UIViewController {

    @IBOutlet weak var restofItemslabel: UILabel!
    @IBOutlet weak var orderPickuptimeLabel: UILabel!
    @IBOutlet weak var orderNumberOfitemsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderItemsLabel: UILabel!
    @IBOutlet weak var OrderIdLabel: UILabel!
    @IBOutlet weak var arravingView: UIView!
    @IBOutlet weak var imageset3View: UIView!
    
    @IBOutlet weak var imageSet3: UIImageView!
    @IBOutlet weak var imageSet2: UIImageView!
    @IBOutlet weak var imageSet1: UIImageView!
    @IBOutlet weak var itemsBAckgroundView: UIView!
    @IBOutlet weak var currentOrderView: UIView!
    @IBOutlet weak var orderHistoryTable: UITableView!
    
    var allOrderHistories : OrderhistoryModel?
    
    var allHistoryData : [OrderHistories]? = [OrderHistories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderHistoryTable.delegate = self
        orderHistoryTable.dataSource = self
        
        orderHistoryTable.register(UINib(nibName: "CustomOrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "0rderHistoryDetailsIdentifier")
        setupUIOrder()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleActiveOrderTap(_:)))
        currentOrderView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(ActiveOrders)
        
        if let ActiveOrder = ActiveOrders {
            
            currentOrderView.isHidden = false
            imageSet1.isHidden = true
            imageSet2.isHidden = true
            imageSet3.isHidden = true
            imageset3View.isHidden = true
        
            
            switch ActiveOrder.CartOrders.count {
            case 1:
                imageSet1.isHidden = false
                imageSet1.image = UIImage(data: ActiveOrder.CartOrders[0].menu_photo_Data!)
                break
            case 2:
                imageSet1.isHidden = false
                imageSet1.image = UIImage(data: ActiveOrder.CartOrders[0].menu_photo_Data!)
                imageSet2.isHidden = false
                imageSet2.image = UIImage(data: ActiveOrder.CartOrders[1].menu_photo_Data!)
                break
            case 3:
                imageSet1.isHidden = false
                imageSet1.image = UIImage(data: ActiveOrder.CartOrders[0].menu_photo_Data!)
                imageSet2.isHidden = false
                imageSet2.image = UIImage(data: ActiveOrder.CartOrders[1].menu_photo_Data!)
                imageSet3.isHidden = false
                imageSet3.image = UIImage(data: ActiveOrder.CartOrders[2].menu_photo_Data!)
                break
            case 4...ActiveOrder.CartOrders.count :
                imageSet1.isHidden = false
                imageSet1.image = UIImage(data: ActiveOrder.CartOrders[0].menu_photo_Data!)
                imageSet2.isHidden = false
                imageSet2.image = UIImage(data: ActiveOrder.CartOrders[1].menu_photo_Data!)
                imageSet3.isHidden = false
                imageSet3.image = UIImage(data: ActiveOrder.CartOrders[2].menu_photo_Data!)
                imageset3View.isHidden = false
                restofItemslabel.text = "+ \(ActiveOrder.CartOrders.count - 3)"
                break
            default:
                print("switch case problem")
                break
            }
            
            OrderIdLabel.text = "ORDER ID #12000\(ActiveOrder.OrderId)"
            orderNumberOfitemsLabel.text = "\(ActiveOrder.CartOrders.count) Items"
            var tempitemNames = ""
            var dataIterations = 0
            for x in ActiveOrder.CartOrders {
                tempitemNames += x.menu_Name + " Q \(x.menu_quantity!)\n"
                if dataIterations > 2 {
                    tempitemNames += "more..."
                    break
                }
                dataIterations += 1
            }
            orderItemsLabel.text = tempitemNames
            
            if let outputDateString = Date().convertTo12HourFormat(dateString: ActiveOrder.pickup_time) {
                orderPickuptimeLabel.text = outputDateString
            } else {
                print("Invalid date string")
            }
        }
        else{
            currentOrderView.isHidden = true
        }
        
        fetchAllOrders()
    }
    
    
    func fetchAllOrders(){
        
        let params : [String : String] = [
                "Mode" : "fetchOrder",
                "RegId": "2"
            ]

        print(params)
        print((Constants().BASEURL + Constants.APIPaths().fetchMenu))

        AF.request((Constants().BASEURL + Constants.APIPaths().AddOrder), method: .post, parameters:params, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
                print(JSON(data))
                let decoder = JSONDecoder()
                do{

                    let jsonData = try decoder.decode(OrderhistoryModel.self, from: data)
                    self.allOrderHistories = jsonData
 
                    
                    if let orders = self.allOrderHistories?.histories, let allMenuDAta = AllMenuDatas?.AllMenu{
                        for x in 0..<orders.count {
                            for y in 0..<orders[x].Orders.count{
                                for z in 0..<allMenuDAta.count {
                                    if orders[x].Orders[y].order_no == AllMenuDatas?.AllMenu[z].menu_id{
                                        self.allOrderHistories?.histories[x].Orders[y].updateOrderName(orderName: AllMenuDatas?.AllMenu[z].menu_Name ?? "have to work")
                                        if let imageDAta = AllMenuDatas?.AllMenu[z].menu_photo_Data {
                                            self.allOrderHistories?.histories[x].Orders[y].updateOrderImage(orderImageData: imageDAta)
                                        }
                                        else{
                                            if let imageDAta = self.updateWholeImageData(x: x, y: y, z: z){
                                                self.allOrderHistories?.histories[x].Orders[y].updateOrderImage(orderImageData: imageDAta)
//                                                AllMenuDatas?.AllMenu[z].addImgeData(imageData: imageDAta)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if orders[x].is_accepted == "Completed"{
                                
                            }
                            else{
                                self.allHistoryData?.removeAll()
                                self.allHistoryData?.append(orders[x])
                                self.orderHistoryTable.reloadData()
                            }
                        }
                    }
                    
                    print(self.allOrderHistories)
                    
//                    AllMenuDatas = jsonData
//                    self.populateCollectionViews()
//                    self.loadingProtocol(with: self.loading! ,false)

                }
                catch{
                    print(response.result)
//                    self.loadingProtocol(with: self.loading! ,false)
                    print("decoder error")
                }

            case .failure(let error):
//                self.loadingProtocol(with: self.loading! ,false)
                self.showAlert(title: "network intrepsion", content: "Something went wrong! please try again after some time")
                print(error)
            }
        }
        
    }
    
    private func updateWholeImageData(x : Int, y : Int, z : Int) -> Data?{
        
//        if let image = UIImage(named: "customPizza") {
//            if let imageData = image.pngData(){
        
        var responseComming = Data()
        
        if let imageName = AllMenuDatas?.AllMenu[z].menu_Photo {
            AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

             switch response.result {
              case .success(let responseData):
                
                 if (JSON(responseData)["message"]=="Internal server error"){
                     print("NO data comming")
                 }
                 else{
                     responseComming = responseData!
                     AllMenuDatas?.AllMenu[z].addImgeData(imageData: responseData!)
                 }
              case .failure(let error):
                  print("error--->",error)
              }
          }
        }
        return responseComming
    }
    
    @objc func handleActiveOrderTap(_ gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "OrderHistoryDetailsViewController") as! OrderHistoryDetailsViewController
        viewC.ActiveOrderData = ActiveOrders
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    private func setupUIOrder(){
        
        currentOrderView.layer.cornerRadius = 20
        currentOrderView.layer.borderWidth = 0.5
        currentOrderView.layer.borderColor = UIColor(named: "GreenColor")?.cgColor
        
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.topLeft,
            UIRectCorner.bottomRight
        ])

        let cornerRadii = CGSize(
            width: 20.0,
            height: 20.0
        )

        let maskPath = UIBezierPath(
            roundedRect: itemsBAckgroundView.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = itemsBAckgroundView.bounds

        itemsBAckgroundView.layer.mask = maskLayer
        arravingView.layer.cornerRadius = arravingView.frame.width / 2
        imageset3View.layer.cornerRadius = imageset3View.frame.width / 2
        imageSet1.layer.borderWidth = 1
        imageSet1.layer.cornerRadius = imageSet1.frame.width / 2
        imageSet1.layer.borderColor = UIColor.white.cgColor
        imageSet2.layer.borderWidth = 1
        imageSet2.layer.cornerRadius = imageSet2.frame.width / 2
        imageSet2.layer.borderColor = UIColor.white.cgColor
        
        imageset3View.layer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1).cgColor;
        imageset3View.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageset3View.layer.shadowOpacity = 0.57;
        imageset3View.layer.shadowRadius = 5;
        
    }
    
}

extension OrderHistoryViewController : UITableViewDelegate{
}

extension OrderHistoryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allHistoryData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderHistoryTable.dequeueReusableCell(withIdentifier: "0rderHistoryDetailsIdentifier", for: indexPath) as! CustomOrderHistoryTableViewCell
//        cell.
        
        return cell
        
    }
    
}
