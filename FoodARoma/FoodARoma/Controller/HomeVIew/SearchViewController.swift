//
//  SearchViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-05.
//

import UIKit

class SearchViewController: UIViewController {
    
    var AllMenuData : [allMenu]?
    var searchMenuData : [allMenu]? = [allMenu]()

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        search.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchTableView.register(UINib(nibName: "HomeMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "homeTableViewidentifier")
        
        searchMenuData = AllMenuData
        print(searchMenuData?.count)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
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
        }
        return cell
    }
    
    
}

extension SearchViewController : UITableViewDelegate{
    
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
