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

class HomeViewController: UIViewController {

    @IBOutlet weak var specialCollectionVew: UICollectionView!
    @IBOutlet weak var regularMenuCollectionVew: UICollectionView!
    @IBOutlet weak var BeverageCollctionView: UICollectionView!
    
    var loading : (NVActivityIndicatorView,UIView)?
    
    var AllMenuItems : AllMenuModel?
    var specialMenu : [allMenu]? = [allMenu]()
    var regMenu : [allMenu]? = [allMenu]()
    var bevMenu : [allMenu]? = [allMenu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        specialCollectionVew.delegate = self
        specialCollectionVew.dataSource = self
        regularMenuCollectionVew.dataSource = self
        regularMenuCollectionVew.delegate = self
        BeverageCollctionView.dataSource = self
        BeverageCollctionView.delegate = self
        
        
        specialCollectionVew.register(UINib(nibName: "HomeMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeMenuCelliIdentifier")
        regularMenuCollectionVew.register(UINib(nibName: "HomeMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeMenuCelliIdentifier")
        BeverageCollctionView.register(UINib(nibName: "BeverageMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBeverageIdentifier")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
        fetchAllMenu()
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
                else if (x.menu_Cat == "bev"){
                    bevMenu?.append(x)
                }
            }
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
                    //                print(JSON(data))
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
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
                    cell1.ratingLabel.text = "4.5"
                    cell1.timeLabel.text = specialmenuitem[indexPath.row].menu_Time + " Min"
                    cell1.descLabel.text = specialmenuitem[indexPath.row].menu_Dec
                }
                return cell1
                
            case regularMenuCollectionVew:
                let cell2 = regularMenuCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
                if let regularMenu = regMenu {
                    cell2.menuNameLabel.text = regularMenu[indexPath.row].menu_Name
                    cell2.priceLabel.text = "$ "+regularMenu[indexPath.row].menu_Price
                    cell2.ratingLabel.text = "4.5"
                    cell2.timeLabel.text = regularMenu[indexPath.row].menu_Time + " Min"
                    cell2.descLabel.text = regularMenu[indexPath.row].menu_Dec
                }
                
                return cell2
            
            case BeverageCollctionView:
                cell = BeverageCollctionView.dequeueReusableCell(withReuseIdentifier: "HomeBeverageIdentifier", for: indexPath) as! BeverageMenuCollectionViewCell
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


