//
//  SearchViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-05.
//

import UIKit

class SearchViewController: UIViewController {
    
    var AllMenuData : AllMenuModel?

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchTableView.register(UINib(nibName: "HomeMenuCollectionViewCell", bundle: nil), forCellReuseIdentifier: "HomeMenuCelliIdentifier")

        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
}

extension SearchViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllMenuData?.AllMenu.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeMenuCollectionViewCell = searchTableView.dequeueReusableCell(withIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell

//        if let menuitem = AllMenuData?.AllMenu {
//            cell.menuNameLabel.text = menuitem[indexPath.row].menu_Name
//            cell.priceLabel.text = "$ "+menuitem[indexPath.row].menu_Price
//            cell.ratingLabel.text = "4.5"
//            cell.timeLabel.text = menuitem[indexPath.row].menu_Time + " Min"
//            cell.descLabel.text = menuitem[indexPath.row].menu_Dec
//        }
        return cell
    }
    
    
}

extension SearchViewController : UITableViewDelegate{
    
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
