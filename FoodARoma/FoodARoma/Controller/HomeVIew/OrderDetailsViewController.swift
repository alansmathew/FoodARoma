//
//  OrderDetailsViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-02.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var bevCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bevCollectionView.delegate = self
        bevCollectionView.dataSource = self
        bevCollectionView.register(UINib(nibName: "BeverageMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBeverageIdentifier")
        
        topView.layer.cornerRadius = 20
        topView.layer.shadowColor = UIColor.black.cgColor;
        topView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topView.layer.shadowOpacity = 0.12;
        topView.layer.shadowRadius = 20;
        
        
    }

}

extension OrderDetailsViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bevCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeBeverageIdentifier", for: indexPath) as! BeverageMenuCollectionViewCell
        return cell
    }
    
    
}

extension OrderDetailsViewController : UICollectionViewDelegate{

}
