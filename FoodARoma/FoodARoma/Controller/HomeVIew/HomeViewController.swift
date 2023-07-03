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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case specialCollectionVew:
            let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            navigationController?.pushViewController(viewC, animated: true)
            
        case BeverageCollctionView:
//            still have to work on this
            let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            navigationController?.pushViewController(viewC, animated: true)
            
        default:
            let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            navigationController?.pushViewController(viewC, animated: true)
        }
    
        
    }
    
}


