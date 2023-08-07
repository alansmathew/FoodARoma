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
//                                    print(JSON(data))
                let decoder = JSONDecoder()
                do{
                    let jsonData = try decoder.decode(AllMenuModel.self, from: data)
                    AllMenuDatas = jsonData
                    
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
                print(JSON(data))
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
        for x in 0..<(AllActiveOrders?.count ?? 0){
            
            if let OrderData = AllActiveOrders{
                for yy in 0..<OrderData.count{
                    // ethu Active order enn akathatnu
                    if let allMenu = AllMenuDatas?.AllMenu {
                        for zz in allMenu{
                            if AllActiveOrders?[x].Orders[yy].order_no == zz.menu_id {
                                if let menuPhotData = zz.menu_photo_Data {
                                    AllActiveOrders?[x].Orders[yy].updateOrderImage(orderImageData: menuPhotData)
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
}
