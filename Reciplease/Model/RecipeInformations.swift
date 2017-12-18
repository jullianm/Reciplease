//
//  RecipeInformations.swift
//  Reciplease
//
//  Created by jullianm on 15/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import Foundation

struct RecipeInformations {
    
    let name: String
    let ingredients: String
    let portions: String
    let rating: String?
    let time: String?
    let image: String?
    
    
    init(name: String, ingredients: String, portions: String, rating: String?, time: String?, image: String?) {
        
        self.name = name
        self.ingredients = ingredients
        self.portions = portions
        self.rating = rating
        self.time = time
        self.image = image
    }
}
