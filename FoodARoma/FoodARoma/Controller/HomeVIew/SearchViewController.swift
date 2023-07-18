//
//  SearchViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-05.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class SearchViewController: UIViewController {
    
    var AllMenuData : [allMenu]?
    var searchMenuData : [allMenu]? = [allMenu]()

    @IBOutlet weak var headingLAbel: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    var commingPlatform = "Search"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        search.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchTableView.register(UINib(nibName: "HomeMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "homeTableViewidentifier")
        
        searchMenuData = AllMenuData
        print(searchMenuData?.count)
        
        headingLAbel.text = commingPlatform

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func loadImageInCell(cellData : HomeMenuTableViewCell, cellImageName : String?){
        if let imageName = cellImageName {
            AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

             switch response.result {
              case .success(let responseData):
                
                 if (JSON(responseData)["message"]=="Internal server error"){
                     print("NO data comming")
                     cellData.menuImage.image = UIImage(named: "imagebackground")
                     
                 }
                 else{
                     cellData.menuImage.image = UIImage(data: responseData!, scale:1)
                 }
            
              case .failure(let error):
                  print("error--->",error)
              }
          }
        }
    }
}

extension SearchViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMenuData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeMenuTableViewCell = searchTableView.dequeueReusableCell(withIdentifier: "homeTableViewidentifier", for: indexPath) as! HomeMenuTableViewCell

        if let menuitem = searchMenuData, menuitem.count > indexPath.row {
            cell.menuName.text = menuitem[indexPath.row].menu_Name
            cell.menuPrice.text = "$ "+menuitem[indexPath.row].menu_Price
            cell.menuRating.text = "4.5"
            cell.menuTime.text = menuitem[indexPath.row].menu_Time + " Min"
            cell.menuDec.text = menuitem[indexPath.row].menu_Dec
            loadImageInCell(cellData: cell, cellImageName: menuitem[indexPath.row].menu_Photo)
        }
        return cell
    }
    
    
}

extension SearchViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        viewC.SelectedOrder = searchMenuData![indexPath.row]
        navigationController?.pushViewController(viewC, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                
                if self.search.text?.count ?? 0 > 1 {
                    let x = self.searchMenuData![indexPath.row]
                    if let menudata = self.AllMenuData {
                        var count = 0
                        for y in menudata {
                            if y.menu_Name == x.menu_Name {
                                self.AllMenuData?.remove(at: count)
                                self.searchMenuData = self.AllMenuData
                                self.search.text = ""
                                self.searchTableView.reloadData()
                            }
                            count += 1
                        }
                    }
                }
                else{
                    self.AllMenuData?.remove(at: indexPath.row)
                    self.searchMenuData = self.AllMenuData
                    self.searchTableView.reloadData()
                    self.search.text = ""
                }
            }
            return UISwipeActionsConfiguration(actions: [action])
        }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 1 {
            searchMenuData?.removeAll()
            if let menuData = AllMenuData {
                for x in menuData{
                    if x.menu_Name.lowercased().contains(searchText.lowercased()) {
                        searchMenuData?.append(x)
                    }
                }
            }
        }
        else{
            searchMenuData = AllMenuData
        }
        searchTableView.reloadData()
        
    }
}
