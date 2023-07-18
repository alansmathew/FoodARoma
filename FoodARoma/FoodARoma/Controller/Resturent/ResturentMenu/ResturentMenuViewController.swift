//
//  ResturentMenuViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-09.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ResturentMenuViewController: UIViewController {

    @IBOutlet weak var ResturentspecialCollectionVew: UICollectionView!
    @IBOutlet weak var ResturentregularMenuCollectionVew: UICollectionView!
    @IBOutlet weak var ResturentBeverageCollctionView: UICollectionView!
    
    private var loading : (NVActivityIndicatorView,UIView)?
    
    private var AllMenuItems : AllMenuModel?
    private var specialMenu : [allMenu]? = [allMenu]()
    private var regMenu : [allMenu]? = [allMenu]()
    private var bevMenu : [allMenu]? = [allMenu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        ResturentspecialCollectionVew.delegate = self
        ResturentspecialCollectionVew.dataSource = self
        ResturentregularMenuCollectionVew.dataSource = self
        ResturentregularMenuCollectionVew.delegate = self
        ResturentBeverageCollctionView.dataSource = self
        ResturentBeverageCollctionView.delegate = self
        
        ResturentspecialCollectionVew.register(UINib(nibName: "HomeMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeMenuCelliIdentifier")
        ResturentregularMenuCollectionVew.register(UINib(nibName: "HomeMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeMenuCelliIdentifier")
        ResturentBeverageCollctionView.register(UINib(nibName: "BeverageMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBeverageIdentifier")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
        fetchAllMenu()
    }
    
    func populateCollectionViews(){
//        print(AllMenuItems)
//        print(regMenu)
        if let allmenuitems = AllMenuItems {
            for x in allmenuitems.AllMenu{
                if (x.menu_Cat == "special"){
                    specialMenu?.append(x)
                }
                else if (x.menu_Cat == "menu"){
                    regMenu?.append(x)
                }
                else if (x.menu_Cat == "bev"){
                    bevMenu?.append(x)
                }
            }
            ResturentspecialCollectionVew.reloadData()
            ResturentregularMenuCollectionVew.reloadData()
            ResturentBeverageCollctionView.reloadData()
        }
    }
    
    private  func loadImageInCell(cellData : HomeMenuCollectionViewCell, cellImageName : String?){
        print(cellImageName)
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
                 }
            
              case .failure(let error):
                  print("error--->",error)
              }
          }
        }
    }
    
    private func fetchAllMenu(){
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

    @IBAction func addmenuClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ResturentAddOrderStoryboard", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "ResturentAddNewOrderViewController") as! ResturentAddNewOrderViewController
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func shoeMoreBev(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        viewC.commingPlatform = "Beverages"
        viewC.AllMenuData = bevMenu
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func showMoreMenu(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        viewC.AllMenuData = regMenu
        viewC.commingPlatform = "Menu"
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func ShowMoreSpecial(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        viewC.commingPlatform = "Special Menus"
        viewC.AllMenuData = specialMenu
        navigationController?.pushViewController(viewC, animated: true)
    }
}

extension ResturentMenuViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case ResturentspecialCollectionVew:
            return specialMenu?.count ?? 0
        case ResturentregularMenuCollectionVew:
            return regMenu?.count ?? 0
        case ResturentBeverageCollctionView:
            return bevMenu?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        switch collectionView {
            case ResturentspecialCollectionVew:
                let cell1 = ResturentspecialCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
                if let specialmenuitem = specialMenu {
                    cell1.menuNameLabel.text = specialmenuitem[indexPath.row].menu_Name
                    cell1.priceLabel.text = "$ "+specialmenuitem[indexPath.row].menu_Price
                    cell1.ratingLabel.text = "4.5"
                    cell1.timeLabel.text = specialmenuitem[indexPath.row].menu_Time + " Min"
                    cell1.descLabel.text = specialmenuitem[indexPath.row].menu_Dec
                    loadImageInCell(cellData: cell1, cellImageName: specialmenuitem[indexPath.row].menu_Photo)
                }
                return cell1
                
            case ResturentregularMenuCollectionVew:
                let cell2 = ResturentregularMenuCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
                if let regularMenu = regMenu {
                    cell2.menuNameLabel.text = regularMenu[indexPath.row].menu_Name
                    cell2.priceLabel.text = "$ "+regularMenu[indexPath.row].menu_Price
                    cell2.ratingLabel.text = "4.5"
                    cell2.timeLabel.text = regularMenu[indexPath.row].menu_Time + " Min"
                    cell2.descLabel.text = regularMenu[indexPath.row].menu_Dec
                    loadImageInCell(cellData: cell2, cellImageName: regularMenu[indexPath.row].menu_Photo)
                }
                
                return cell2
            
            case ResturentBeverageCollctionView:
                cell = ResturentBeverageCollctionView.dequeueReusableCell(withReuseIdentifier: "HomeBeverageIdentifier", for: indexPath) as! BeverageMenuCollectionViewCell
            default:
                cell = ResturentspecialCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
        }
        return cell
    }
    
}

extension ResturentMenuViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case ResturentspecialCollectionVew:
            let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            viewC.SelectedOrder = specialMenu![indexPath.row]
            navigationController?.pushViewController(viewC, animated: true)
            
        case ResturentBeverageCollctionView:
//            still have to work on this
            let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
//            viewC.SelectedOrder = regMenu![indexPath.row]
            navigationController?.pushViewController(viewC, animated: true)
            
        default:
            let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            viewC.SelectedOrder = regMenu![indexPath.row]
            navigationController?.pushViewController(viewC, animated: true)
        }
    
        
    }
}
