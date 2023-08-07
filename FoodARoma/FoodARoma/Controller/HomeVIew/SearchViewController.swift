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
    private let refreshControl = UIRefreshControl()
    
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
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        searchTableView.refreshControl = refreshControl

        
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
    
    func showDeleteWarning(for indexPath: IndexPath) {

        let alert = UIAlertController(title: "Delete Menu ?", message: "Deleteion of a menu will cause issue while orderig. if there is anyone trying to order this menu at this time of deletion might still get through.", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                
                if self.search.text?.count ?? 0 > 1 {
                    let x = self.searchMenuData![indexPath.row]
                    if let menudata = self.AllMenuData {
                        var count = 0
                        for y in menudata {
                            if y.menu_Name == x.menu_Name {
                                self.AllMenuData?.remove(at: count)
                                self.searchMenuData = self.AllMenuData
                                self.search.text = ""
//                                self.searchTableView.reloadData()
                                self.searchTableView.deleteRows(at: [indexPath], with: .fade)
                            }
                            count += 1
                        }
                    }
                }
                else{
                    self.AllMenuData?.remove(at: indexPath.row)
                    self.searchMenuData = self.AllMenuData
//                    self.searchTableView.reloadData()
                    self.searchTableView.deleteRows(at: [indexPath], with: .fade)
                    self.search.text = ""
                }
            }
        }

        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        //Present the alert controller
        present(alert, animated: true, completion: nil)
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
            if let photoData = menuitem[indexPath.row].menu_photo_Data {
                cell.menuImage.image = UIImage(data: photoData, scale: 1)
            }
            else{
                loadImageInCell(cellData: cell, cellImageName: menuitem[indexPath.row].menu_Photo)
            }

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
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
             DispatchQueue.main.async {
                 self.showDeleteWarning(for: indexPath)
             }

             success(true)
         })

         modifyAction.image = UIImage(named: "delete")
         modifyAction.backgroundColor = .red
        
        if let userType = UserDefaults.standard.string(forKey: "USERTYPE"){
            if userType == "restaurant"{
                return UISwipeActionsConfiguration(actions: [modifyAction])
            }
        }
        return nil
        
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

extension SearchViewController {
    @objc private func refreshData() {
        searchTableView.reloadData()
        
        // End the refreshing animation
        refreshControl.endRefreshing()
    }
}
