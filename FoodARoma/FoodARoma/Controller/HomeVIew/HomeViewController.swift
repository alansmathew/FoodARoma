//
//  HomeViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-04.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var specialCollectionVew: UICollectionView!
    @IBOutlet weak var regularMenuCollectionVew: UICollectionView!
    @IBOutlet weak var BeverageCollctionView: UICollectionView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextbox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        uiUpdate()

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
    
    func uiUpdate(){
        searchView.layer.cornerRadius = 18
    }

}


extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case specialCollectionVew:
            return 3
        case regularMenuCollectionVew:
            return 4
        case BeverageCollctionView:
            return 5
        default:
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        switch collectionView {
        case specialCollectionVew:
            cell = specialCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
        case regularMenuCollectionVew:
            cell = regularMenuCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
        case BeverageCollctionView:
            cell = BeverageCollctionView.dequeueReusableCell(withReuseIdentifier: "HomeBeverageIdentifier", for: indexPath) as! BeverageMenuCollectionViewCell
        default:
            cell = specialCollectionVew.dequeueReusableCell(withReuseIdentifier: "HomeMenuCelliIdentifier", for: indexPath) as! HomeMenuCollectionViewCell
        }
        
        return cell
    }
    
}

extension HomeViewController : UICollectionViewDelegate {
    
}

