//
//  RecipeInformations.swift
//  Reciplease
//
//  Created by jullianm on 15/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import Foundation

struct RecipeInformations {
    
    let id: String
    let ingredients: String
    let rating: String
    let recipeName: String
    let recipeImage: URL
    let cookingTime: String

    
    init(id: String,ingredients: String, rating: String, recipeName: String, recipeImage: URL, cookingTime: String) {
        
        self.id = id
        self.ingredients = ingredients
        self.rating = rating
        self.recipeName = recipeName
        self.recipeImage = recipeImage
        self.cookingTime = cookingTime
    
    }
}
