//
//  OrderHistoryViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-29.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

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
    
    var defaultImageData = Data()
    
    private var loading : (NVActivityIndicatorView,UIView)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(allHistoryData?.count)
        
        orderHistoryTable.delegate = self
        orderHistoryTable.dataSource = self
        
        orderHistoryTable.register(UINib(nibName: "CustomOrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "0rderHistoryDetailsIdentifier")
        orderHistoryTable.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyCellIdentifier")
        setupUIOrder()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleActiveOrderTap(_:)))
        currentOrderView.addGestureRecognizer(tapGesture)
        
        if let image = UIImage(named: "customPizza") {
            if let imageData = image.pngData(){
                defaultImageData = imageData
            }}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateActiveOrderUI()
        fetchAllOrders()
    }
    
    
    private func updateActiveOrderUI(){
        if let ActiveOrder = ActiveOrders {
            
            currentOrderView.isHidden = false
            imageSet1.isHidden = true
            imageSet2.isHidden = true
            imageSet3.isHidden = true
            imageset3View.isHidden = true
            
            if let statusData = ActiveOrders?.is_accepted{
                statusLabel.text = ActiveOrders?.is_accepted
                arravingView.backgroundColor = UIColor(named: "GreenColor")
                if ActiveOrders?.is_accepted == "Ready"{
                    arravingView.backgroundColor = .blue
                }
            }
        
            
            switch ActiveOrder.CartOrders.count {
            case 1:
                imageSet1.isHidden = false
                if let imageData = ActiveOrder.CartOrders[0].menu_photo_Data{
                    imageSet1.image = UIImage(data: imageData)
                }
                else{
                    updateImageData(imageField: imageSet1, imageString: ActiveOrder.CartOrders[0].menu_Photo!, indexData: 0)
                }
                break
            case 2:
                imageSet1.isHidden = false
                imageSet2.isHidden = false
                
                if let imageData = ActiveOrder.CartOrders[0].menu_photo_Data{
                    imageSet1.image = UIImage(data: imageData)
                }
                else{
                    updateImageData(imageField: imageSet1, imageString: ActiveOrder.CartOrders[0].menu_Photo!, indexData: 0)
                }
                
                if let imageData = ActiveOrder.CartOrders[1].menu_photo_Data{
                    imageSet2.image = UIImage(data: imageData)
                }
                else{
                    updateImageData(imageField: imageSet2, imageString: ActiveOrder.CartOrders[1].menu_Photo!, indexData: 1)
                }
                break
            case 3:
                imageSet1.isHidden = false
                imageSet2.isHidden = false
                imageSet3.isHidden = false
                
                
                if let imageData = ActiveOrder.CartOrders[0].menu_photo_Data{
                    imageSet1.image = UIImage(data: imageData)
                }
                else{
                    updateImageData(imageField: imageSet1, imageString: ActiveOrder.CartOrders[0].menu_Photo!, indexData: 0)
                }
                
                if let imageData = ActiveOrder.CartOrders[1].menu_photo_Data{
                    imageSet2.image = UIImage(data: imageData)
                }
                else{
                    updateImageData(imageField: imageSet2, imageString: ActiveOrder.CartOrders[1].menu_Photo!, indexData: 1)
                }
                
                if let imageData = ActiveOrder.CartOrders[2].menu_photo_Data{
                    imageSet3.image = UIImage(data: imageData)
                }
                else{
                    updateImageData(imageField: imageSet3, imageString: ActiveOrder.CartOrders[2].menu_Photo!, indexData: 2)
                }
                
                break
                
            case 4...ActiveOrder.CartOrders.count :
                imageSet1.isHidden = false
                imageSet2.isHidden = false
                imageSet3.isHidden = false
                
                
                
                if let imageData = ActiveOrder.CartOrders[0].menu_photo_Data{
                    imageSet1.image = UIImage(data: imageData)
                }
                else{
                    updateImageData(imageField: imageSet1, imageString: ActiveOrder.CartOrders[0].menu_Photo!, indexData: 0)
                }
                
                if let imageData = ActiveOrder.CartOrders[1].menu_photo_Data{
                    imageSet2.image = UIImage(data: imageData)
                }
                else{
                    updateImageData(imageField: imageSet2, imageString: ActiveOrder.CartOrders[1].menu_Photo!, indexData: 1)
                }
                
                if let imageData = ActiveOrder.CartOrders[2].menu_photo_Data{
                    imageSet3.image = UIImage(data: imageData)
                }
                else{
                    updateImageData(imageField: imageSet3, imageString: ActiveOrder.CartOrders[2].menu_Photo!, indexData: 2)
                }
                
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
    }
    
    func fetchAllOrders(){
        
        if let userId = UserDefaults.standard.string(forKey: "USERID"){
            
            let params : [String : String] = [
                    "Mode" : "fetchOrder",
                    "RegId": "\(userId)"
                ]
            
            loading = customAnimation()
            loadingProtocol(with: loading! ,true)

            AF.request((Constants().BASEURL + Constants.APIPaths().AddOrder), method: .post, parameters:params, encoder: .json).responseData { response in
                switch response.result{
                case .success(let data):
                    print(JSON(data))
                    let decoder = JSONDecoder()
                    do{

                        let jsonData = try decoder.decode(OrderhistoryModel.self, from: data)
                        self.allOrderHistories = jsonData
                        print(self.allOrderHistories)
                        
                        if let orders = self.allOrderHistories?.histories, let allMenuDAta = AllMenuDatas?.AllMenu{

                            for x in 0..<orders.count {
                                for y in 0..<orders[x].Orders.count{
                                    for z in 0..<allMenuDAta.count {
                                        if orders[x].Orders[y].order_no == AllMenuDatas?.AllMenu[z].menu_id{
                                            self.allOrderHistories?.histories[x].Orders[y].updateOrderName(orderName: AllMenuDatas?.AllMenu[z].menu_Name ?? "have to work")
                                            if let imageDAta = AllMenuDatas?.AllMenu[z].menu_photo_Data {
                                                print("photo Data1 : \(imageDAta)")
                                                self.allOrderHistories?.histories[x].Orders[y].updateOrderImage(orderImageData: imageDAta)
                                            }
                                            else{
                                                print("photo Data2 : dosent have")
                                                if let imageName = AllMenuDatas?.AllMenu[z].menu_Photo {
                                                    AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

                                                     switch response.result {
                                                      case .success(let responseData):
                                                        
                                                         if (JSON(responseData)["message"]=="Internal server error"){
                                                             print("NO data comming")
                                                         }
                                                         else{
                                                             AllMenuDatas?.AllMenu[z].addImgeData(imageData: responseData!)
                                                             self.allOrderHistories?.histories[x].Orders[y].updateOrderImage(orderImageData: responseData!)
                                                             self.updateHIstoriesOrders()
                                                         }
                                                      case .failure(let error):
                                                          print("error--->",error)
                                                      }
                                                  }
                                                }
                                            }
                                        }
                                        else{
                                            if orders[x].Orders[y].order_no == -1000001{
                                                self.allOrderHistories?.histories[x].Orders[y].updateOrderName(orderName: "Special / Custom Order")
                                                self.allOrderHistories?.histories[x].Orders[y].updateOrderImage(orderImageData: self.defaultImageData )
//                                              print("commming here \(orders[x].Orders[y])")
                                            }
                                        }
                                    }
                                }

                            }
                        }
                        
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
    
    private func updateHIstoriesOrders(){
        self.allHistoryData?.removeAll()
        if let orders = self.allOrderHistories?.histories, let allMenuDAta = AllMenuDatas?.AllMenu{
            for x in 0..<orders.count {
                if orders[x].is_accepted == "Completed"{
                    self.allHistoryData?.append(self.allOrderHistories!.histories[x])
                    self.orderHistoryTable.reloadData()
                }
                else{
                    var totprice = 0.00
                    if ActiveOrders?.OrderId != orders[x].order_id{
                        print("comming here")
                        if let menu = AllMenuDatas {
                            
                            var tempArray : [allMenu]? = [allMenu]()
                            var customPissaDataTemp : [allMenu]? = [allMenu]()
                            for xx in orders[x].Orders{
                                if xx.order_no == -1000001{
                                    let xCustom = allMenu(menu_id: -1000001, menu_Time: "", menu_Cat: "Custom", menu_Price: "10.99", menu_Name: "Custom / Special", menu_Dec: xx.order_dis, avg_Rating: "0", total_Ratings: "0", menu_photo_Data: defaultImageData, menu_quantity: xx.order_qty, ratings: [Ratings(comment: "0", rating: "0")])
                                    customPissaDataTemp?.append(xCustom)
                                }
                                else{
                                    for y in menu.AllMenu{
                                        if xx.order_no == y.menu_id {
                                            totprice += Double(y.menu_Price) ?? 0.00
                                            var xdata = y
                                            xdata.addMenuQuantity(qData: xx.order_qty)
                                            tempArray?.append(xdata)
                                        }
                                    }
                                }
                            }
                            //makeing custom pizza in orders
                            if let cusData = customPissaDataTemp{
                                var cusPrice = totprice/Double(cusData.count)
                                for yyz in 0..<cusData.count{
                                    customPissaDataTemp?[yyz].menu_Price = "\(cusPrice)"
                                    tempArray?.append(customPissaDataTemp![yyz])
                                }
                            }
                          
                            print("temp order - > \(tempArray)")
                            if let Aorders = tempArray{
                                let currentOrder = ActiveOrderModel(OrderId: orders[x].order_id, pickup_time: orders[x].datetime, is_accepted: orders[x].is_accepted, CartOrders: Aorders)
                                ActiveOrders = currentOrder
                                updateActiveOrderStatus()
                                updateActiveOrderUI()
                            }
                        }
                    }
                    else {
//                        checkActiveorderUpdate()
                        ActiveOrders?.updateOrderTime(TimeData: orders[x].datetime)
                        ActiveOrders?.is_accepted = orders[x].is_accepted
                        updateActiveOrderUI()
                    
                        print(" here Active done : \(ActiveOrders)")
                    }
//                    // else api all for order that gets time and update.
                }
            }
        }
    }
    
//    private func checkActiveorderUpdate(){
//
//    }
    
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
    
    private func updateImageData(imageField : UIImageView, imageString : String, indexData : Int) {
            AF.request( Constants().IMAGEURL+imageString,method: .get).response{ response in

             switch response.result {
              case .success(let responseData):

                 if (JSON(responseData)["message"]=="Internal server error"){
                     print("NO data comming")
                 }
                 else{
                     imageField.image = UIImage(data: responseData!)
                     ActiveOrders?.CartOrders[indexData].addImgeData(imageData:responseData!)
                 }
              case .failure(let error):
                  print("error--->",error)
              }
          }
    }
    
    func convertDateString(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM d, yyyy h:mm a"
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
}

extension OrderHistoryViewController : UITableViewDelegate{
}

extension OrderHistoryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Int(allHistoryData?.count ?? 0) == 0 {
            return 1
        }else{
            let caritems = allHistoryData?.count ?? 1
            return Int(allHistoryData?.count ?? 0)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = orderHistoryTable.dequeueReusableCell(withIdentifier: "0rderHistoryDetailsIdentifier", for: indexPath) as! CustomOrderHistoryTableViewCell
        if let orderHistory = allHistoryData, orderHistory.count > 0{
            cell.orderIDLabel.text = "ORDER ID #12000\(orderHistory[indexPath.row].order_id)"
            var tempitemNames = ""
            var dataIterations = 0
            for x in orderHistory[indexPath.row].Orders {
                tempitemNames += (x.order_name ?? "Special / Custom Order") + " Q \(x.order_qty)\n"
                if dataIterations > 2 {
                    tempitemNames += "more..."
                    break
                }
                dataIterations += 1
            }
            
            cell.itemsLabel.text = tempitemNames
            
            cell.imageSet1.isHidden = true
            cell.imageSet2.isHidden = true
            cell.imageSet3.isHidden = true
            cell.imageSet3View.isHidden = true
        
            
            switch orderHistory[indexPath.row].Orders.count {
            case 1:
                cell.imageSet1.isHidden = false
                cell.imageSet1.image = UIImage(data: orderHistory[indexPath.row].Orders[0].order_photo_data ?? defaultImageData)
                break
            case 2:
                cell.imageSet1.isHidden = false
                cell.imageSet1.image = UIImage(data: orderHistory[indexPath.row].Orders[0].order_photo_data ?? defaultImageData)
                cell.imageSet2.isHidden = false
                cell.imageSet2.image = UIImage(data: orderHistory[indexPath.row].Orders[1].order_photo_data ?? defaultImageData)
                break
            case 3:
                cell.imageSet1.isHidden = false
                cell.imageSet1.image = UIImage(data: orderHistory[indexPath.row].Orders[0].order_photo_data ?? defaultImageData)
                cell.imageSet2.isHidden = false
                cell.imageSet2.image = UIImage(data: orderHistory[indexPath.row].Orders[1].order_photo_data ?? defaultImageData)
                cell.imageSet3.isHidden = false
                cell.imageSet3.image = UIImage(data: orderHistory[indexPath.row].Orders[2].order_photo_data ?? defaultImageData)
                break
            case 4...orderHistory[indexPath.row].Orders.count :
                cell.imageSet1.isHidden = false
                cell.imageSet1.image = UIImage(data: orderHistory[indexPath.row].Orders[0].order_photo_data ?? defaultImageData)
                cell.imageSet2.isHidden = false
                cell.imageSet2.image = UIImage(data: orderHistory[indexPath.row].Orders[1].order_photo_data ?? defaultImageData)
                cell.imageSet3.isHidden = false
                cell.imageSet3.image = UIImage(data: orderHistory[indexPath.row].Orders[2].order_photo_data ?? defaultImageData)
                cell.imageSet3View.isHidden = false
                cell.itemLeftCountLabel.text = "+ \(orderHistory[indexPath.row].Orders.count - 3)"
                break
            default:
                print("switch case problem")
                break
            }
            
            
            cell.itemsCountBottomLabel.text = "\(orderHistory[indexPath.row].Orders.count) items"
            if let outputDateString = convertDateString(orderHistory[indexPath.row].datetime) {
                cell.timeLabel.text = outputDateString
            } else {
                print("Invalid date string")
            }

            
        }
        else{
            print("cell empty")
            let cell = orderHistoryTable.dequeueReusableCell(withIdentifier: "emptyCellIdentifier", for: indexPath) as! EmptyTableViewCell
            return cell
        }
        
        return cell
        
    }
    
}
