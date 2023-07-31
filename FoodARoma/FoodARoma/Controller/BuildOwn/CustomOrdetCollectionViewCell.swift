//
//  CustomOrdetCollectionViewCell.swift
//  FoodARoma
//
//  Created by alan on 2023-07-30.
//

import UIKit

class CustomOrdetCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addtocartbutton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addtocartbutton.layer.cornerRadius = 10
    }

}
