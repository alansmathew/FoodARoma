//
//  CustomOrderHistoryTableViewCell.swift
//  FoodARoma
//
//  Created by alan on 2023-08-04.
//

import UIKit

class CustomOrderHistoryTableViewCell: UITableViewCell {


    @IBOutlet weak var backgrounddView: UIView!
    @IBOutlet weak var itemLeftCountLabel: UILabel!
    @IBOutlet weak var imageSet3View: UIView!
    @IBOutlet weak var imageSet3: UIImageView!
    @IBOutlet weak var imageSet2: UIImageView!
    @IBOutlet weak var imageSet1: UIImageView!
    @IBOutlet weak var bottomItemsView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var itemsCountBottomLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.topLeft,
            UIRectCorner.bottomRight
        ])

        let cornerRadii = CGSize(
            width: 20.0,
            height: 20.0
        )

        let maskPath = UIBezierPath(
            roundedRect: bottomItemsView.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = bottomItemsView.bounds
        bottomItemsView.layer.mask = maskLayer
//        bottomItemsView.layer.masksToBounds = true
        
        backgrounddView.layer.cornerRadius = 20
        backgrounddView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
