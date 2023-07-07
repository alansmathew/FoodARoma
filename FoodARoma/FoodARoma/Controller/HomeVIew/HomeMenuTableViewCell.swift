//
//  HomeMenuTableViewCell.swift
//  FoodARoma
//
//  Created by alan on 2023-07-06.
//

import UIKit

class HomeMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuPrice: UILabel!
    @IBOutlet weak var menuTime: UILabel!
    @IBOutlet weak var menuRating: UILabel!
    @IBOutlet weak var menuDec: UILabel!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var backOfPrice: UIView!
    @IBOutlet weak var backgrounddView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgrounddView.layer.cornerRadius = 29
        // Initialization code
        
        // Specify which corners to round
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.topLeft,
            UIRectCorner.bottomRight
        ])

        // Determine the size of the rounded corners
        let cornerRadii = CGSize(
            width: 20.0,
            height: 20.0
        )

        // A mask path is a path used to determine what
        // parts of a view are drawn. UIBezier path can
        // be used to create a path where only specific
        // corners are rounded
        let maskPath = UIBezierPath(
            roundedRect: backOfPrice.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = backOfPrice.bounds

        backOfPrice.layer.mask = maskLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
