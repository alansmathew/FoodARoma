//
//  ResturentOrdersController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-15.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ResturentOrdersController: UIViewController {

    @IBOutlet weak var ResturentCurrentOrdersTable: UITableView!
    
    private var defaultImageData = Data()
    private var loading : (NVActivityIndicatorView,UIView)?
    var AllActiveOrders : [OrderHistories]? = [OrderHistories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ResturentCurrentOrdersTable.delegate = self
        ResturentCurrentOrdersTable.dataSource = self
        ResturentCurrentOrdersTable.register(UINib(nibName: "ResturentOrderscell", bundle: nil), forCellReuseIdentifier: "ResOrderIdentifier")
        ResturentCurrentOrdersTable.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyCellIdentifier")
    
        if let image = UIImage(named: "customPizza") {
            if let imageData = image.pngData(){
                defaultImageData = imageData
            }}
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchAllOrders()
    }
    
    private func fetchAllOrders(){
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
        let params : [String : String] = [
                "Mode" : "fetchMenu"
            ]
        
        AF.request((Constants().BASEURL + Constants.APIPaths().fetchMenu), method: .post, parameters:params, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
                print("fetched Menus --> \(JSON(data))")
                let decoder = JSONDecoder()
                do{
                    let jsonData = try decoder.decode(AllMenuModel.self, from: data)
                    AllMenuDatas = jsonData
                    
                    bevMenuGlobal?.removeAll()
                    if let allmenuitems = AllMenuDatas {
                        for x in allmenuitems.AllMenu{
                            if (x.menu_Cat == "beverage"){
                                bevMenuGlobal?.append(x)
                            }
                        }
                    }
                    
                    for x in 0..<(AllMenuDatas?.AllMenu.count ?? 0){
                        if let imageName = AllMenuDatas?.AllMenu[x].menu_Photo {
                            AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

                             switch response.result {
                              case .success(let responseData):
                                
                                 if (JSON(responseData)["message"]=="Internal server error"){
                                     print("NO data comming")
                                 }
                                 else{
                                     AllMenuDatas?.AllMenu[x].addImgeData(imageData: responseData!)
                                     self.updateAllActiveOrderWithImages()
                                 }
                              case .failure(let error):
                                  print("error--->",error)
                              }
                          }
                        }
                    }
                    
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
        
        
        let paramss : [String : String] = [
                "Mode" : "listNotCompletedOrders"
            ]

        AF.request((Constants().BASEURL + Constants.APIPaths().AddOrder), method: .post, parameters:paramss, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
                print("Active Orders == > \(JSON(data))")
                let decoder = JSONDecoder()
                do{
                    let jsonData = try decoder.decode(OrderhistoryModel.self, from: data)
                    self.AllActiveOrders = jsonData.histories
                    
//                    self.ResturentCurrentOrdersTable.reloadData()
                    self.loadingProtocol(with: self.loading! ,false)
                    self.updateAllActiveOrderWithImages()

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
    
    func updateAllActiveOrderWithImages(){
        if let OrderData = AllActiveOrders{
        for x in 0..<(OrderData.count){
                for yy in 0..<OrderData[x].Orders.count{
                    if OrderData[x].Orders[yy].order_no == -1000001 {
                        AllActiveOrders?[x].Orders[yy].updateOrderImage(orderImageData: defaultImageData)
                        AllActiveOrders?[x].Orders[yy].updateOrderName(orderName: "Special / Custom Order")
                    }
                    else{
                        // ethu Active order enn akathatnu
                        if let allMenu = AllMenuDatas?.AllMenu {
                            for zz in allMenu{
                                if AllActiveOrders?[x].Orders[yy].order_no == zz.menu_id {
                                    if let menuPhotData = zz.menu_photo_Data {
                                        AllActiveOrders?[x].Orders[yy].updateOrderImage(orderImageData: menuPhotData)
                                        AllActiveOrders?[x].Orders[yy].updateOrderName(orderName: zz.menu_Name)
                                    }
                                    else{
                                        print("We dont have photo data")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        ResturentCurrentOrdersTable.reloadData()
        print("updated weith phto \(AllActiveOrders)")
        
    }

}


extension ResturentOrdersController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Int(AllActiveOrders?.count ?? 0) == 0 {
            return 1
        }else{
            return Int(AllActiveOrders?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ResturentCurrentOrdersTable.dequeueReusableCell(withIdentifier: "ResOrderIdentifier", for: indexPath) as! ResturentOrderscell
        if let orders = AllActiveOrders, orders.count > 0 {
            let currentOreder = orders[indexPath.row]
            cell.orderPErsonName.text = currentOreder.user_name
            cell.orderIDLabel.text = "ORDER ID #12000\(currentOreder.order_id)"
            cell.itemsLAbel.text = "Comone"
            cell.statusText.text = "\(currentOreder.is_accepted)"
            if let outputDateString = Date().convertTo12HourFormat(dateString: currentOreder.datetime) {
                cell.pickuptime.text = outputDateString
            } else {
                print("Invalid date string")
            }
            
            var tempitemNames = ""
            var dataIterations = 0
//            for x in currentOreder.Orders {
//                if let allMEnu = AllMenuDatas?.AllMenu {
//                    for y in allMEnu {
//                        if x.order_no == y.menu_id{
//                            tempitemNames += y.menu_Name + " Q \(x.order_qty)\n"
//                            if dataIterations > 2 {
//                                tempitemNames += "more..."
//                                dataIterations += 1
//                                break
//                            }
//
//                        }
//                    }
//                }
//
//            }
            
            for x in currentOreder.Orders {
                tempitemNames += (x.order_name ?? "Special / Custom Order") + " Q \(x.order_qty)\n"
                if dataIterations > 2 {
                    tempitemNames += "more..."
                    break
                }
                dataIterations += 1
            }
            
            cell.itemsLAbel.text = tempitemNames
            
            
            cell.imageSet1.isHidden = true
            cell.imageset2.isHidden = true
            cell.imageset3.isHidden = true
            cell.imageset3View.isHidden = true
        
            
            switch currentOreder.Orders.count {
            case 1:
                cell.imageSet1.isHidden = false
                cell.imageSet1.image = UIImage(data: currentOreder.Orders[0].order_photo_data ?? defaultImageData)
                break
            case 2:
                cell.imageSet1.isHidden = false
                cell.imageSet1.image = UIImage(data: currentOreder.Orders[0].order_photo_data ?? defaultImageData)
                cell.imageset2.isHidden = false
                cell.imageset2.image = UIImage(data: currentOreder.Orders[1].order_photo_data ?? defaultImageData)
                break
            case 3:
                cell.imageSet1.isHidden = false
                cell.imageSet1.image = UIImage(data: currentOreder.Orders[0].order_photo_data ?? defaultImageData)
                cell.imageset2.isHidden = false
                cell.imageset2.image = UIImage(data: currentOreder.Orders[1].order_photo_data ?? defaultImageData)
                cell.imageset3.isHidden = false
                cell.imageset3.image = UIImage(data: currentOreder.Orders[2].order_photo_data ?? defaultImageData)
                break
            case 4...currentOreder.Orders.count :
                cell.imageSet1.isHidden = false
                cell.imageSet1.image = UIImage(data: currentOreder.Orders[0].order_photo_data ?? defaultImageData)
                cell.imageset2.isHidden = false
                cell.imageset2.image = UIImage(data: currentOreder.Orders[1].order_photo_data ?? defaultImageData)
                cell.imageset3.isHidden = false
                cell.imageset3.image = UIImage(data: currentOreder.Orders[2].order_photo_data ?? defaultImageData)
                cell.imageset3View.isHidden = false
                cell.iamgeItemLAbel.text = "+ \(currentOreder.Orders.count - 3)"
                break
            default:
                print("switch case problem")
                break
            }
            
            cell.totalITemLabel.text = "\(currentOreder.Orders.count) Items"
        }
        else{
            print("cell empty")
            let cell = ResturentCurrentOrdersTable.dequeueReusableCell(withIdentifier: "emptyCellIdentifier", for: indexPath) as! EmptyTableViewCell
            return cell
        }
        return cell
    }
    
}

extension ResturentOrdersController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var tempArray : [allMenu]? = [allMenu]()
        
        var tempPrice = 0.00
        var orgPrice = Double(AllActiveOrders?[indexPath.row].total_price ?? "0.00") ?? 0.00
        orgPrice *= 0.87
        var customPissaDataTemp : [allMenu]? = [allMenu]()
        if let Order = AllActiveOrders?[indexPath.row].Orders, let menu = AllMenuDatas?.AllMenu{
            for x in Order{
                if x.order_no ==  -1000001 {
                    let tempMEu = allMenu( menu_id: x.order_no, menu_Time: "20min", menu_Cat: "Special / custom", menu_Price: "", menu_Name: "Special / Custom", menu_Dec: x.order_dis, avg_Rating: "", total_Ratings: "", menu_Photo: "", menu_photo_Data: defaultImageData, menu_quantity:x.order_qty, ratings: [Ratings(comment: "", rating: "")])
                    customPissaDataTemp?.append(tempMEu)
                }else{
                    for y in menu{
                        if x.order_no == y.menu_id{
                            var xdata = y
                            xdata.addMenuQuantity(qData: x.order_qty)
                            let tempPriceDAta = Double(y.menu_Price) ?? 0.00
                            tempPrice += tempPriceDAta * Double(x.order_qty)
                            tempArray?.append(xdata)
                        }
                    }
                }
            }
            
            if let customPizza = customPissaDataTemp{
                var custPriceLeft = orgPrice - tempPrice
                for y in 0..<customPizza.count {
                    customPissaDataTemp?[y].menu_Price =  String(format: "%.2f", (custPriceLeft / Double(customPizza[y].menu_quantity ?? 1)))
                    tempArray?.append(customPissaDataTemp![y])
                }
            }
          
            
            if let orderData = AllActiveOrders?[indexPath.row], let tEMpORders = tempArray{
                let currentOrder = ActiveOrderModel(OrderId: orderData.order_id, pickup_time: orderData.datetime, is_accepted: orderData.is_accepted, CartOrders: tEMpORders)
                
                let storyboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "OrderHistoryDetailsViewController") as! OrderHistoryDetailsViewController
                viewC.ActiveOrderData = currentOrder
                navigationController?.pushViewController(viewC, animated: true)
            }
        }
  
    

    }
}
