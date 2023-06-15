//
//  HomeMenuCollectionViewCell.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-07.
//

import UIKit

class HomeMenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundCustomView: UIView!
    @IBOutlet weak var amoundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCustomView.layer.cornerRadius = 29
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
            roundedRect: amoundView.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = amoundView.bounds

        amoundView.layer.mask = maskLayer
    }

}
