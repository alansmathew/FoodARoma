//
//  BeverageMenuCollectionViewCell.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-08.
//

import UIKit

class BeverageMenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bevImageVew: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var moneyView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCellView.layer.cornerRadius = 16
        moneyView.layer.cornerRadius = 10
//        moneyView.layer.borderWidth = 1
//        moneyView.layer.borderColor = UIColor.red.cgColor
        
        moneyView.layer.shadowColor = UIColor.black.cgColor;
        moneyView.layer.shadowOffset = CGSize(width: 0, height: 4)
        moneyView.layer.shadowOpacity = 0.13;
        moneyView.layer.shadowRadius = 4.0;
        moneyView.layer.masksToBounds = false;
    }

}
