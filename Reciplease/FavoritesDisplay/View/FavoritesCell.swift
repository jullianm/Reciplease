//
//  FavoritesCell.swift
//  Reciplease
//
//  Created by jullianm on 26/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

class FavoritesCell: UITableViewCell {

    @IBOutlet weak var favoriteRecipeImage: UIImageView!
    @IBOutlet weak var favoriteRecipeName: UILabel!
    @IBOutlet weak var favoriteRecipeIngredients: UILabel!
    @IBOutlet weak var favoriteRecipeRating: UILabel!
    @IBOutlet weak var favoriteRecipeCookingTime: UILabel!
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        layer.locations = [0.7, 1]
        return layer
    }()
    
    
    override func layoutSubviews() {
        gradientLayer.frame = favoriteRecipeImage.bounds
        favoriteRecipeImage.layer.addSublayer(gradientLayer)
    }
}
