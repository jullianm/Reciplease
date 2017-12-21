//
//  RecipeCell.swift
//  Reciplease
//
//  Created by jullianm on 17/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredientsName: UILabel!
    @IBOutlet weak var recipeMark: UILabel!
    @IBOutlet weak var recipeCookingTime: UILabel!
    
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
        gradientLayer.frame = recipeImage.bounds
        recipeImage.layer.addSublayer(gradientLayer)
    }

}
