//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by jullianm on 13/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import XCTest
import UIKit
import CoreData
@testable import Reciplease

class RecipleaseTests: XCTestCase {
    
    // Mocking a Yummly API Request
    func testGivenAnIngredientInputWhenFetchingRecipesListIsCalledThenWeGetRecipesDetails() {
        var recipesTest: [RecipeInformations]?
        let ingredients = ["Strawberry"]
        FetchingRecipesList.getRecipes(ingredients: ingredients) { recipes in
            recipesTest = recipes
        }
        guard let recipes = recipesTest else { return }
        XCTAssertEqual(recipes[0].ingredients, "Sugar, Flour, Large Eggs, Strawberries" , "API Request not working")
    }

    // Testing CoreData objects
     func testGivenARecipeSelectedWhenUserTapToAddToFavoriteThenRecipeIsCorrectlyAddedToCoreData() {
        // Saving
        guard let photo = try? Data(contentsOf: URL(string: "http://i2.yummly.com/Hot-Turkey-Salad-Sandwiches-Allrecipes.l.png")!) else { return }
        let saveRecipes = RecipeInformations(name: "Test", ingredients: "test, test, test, test", portions: ["test portions", "test portions"], rating: "0/0", time: "0", image: photo, instructions: URL(string: "http://jullianmercier.com")!)
        Save.recipe(from: [saveRecipes], at: 0)
        //Fetching
        var fetchRecipes = [RecipeInformations]()
        Fetch.recipe(into: &fetchRecipes)
        XCTAssertEqual(fetchRecipes.count, 1)
    }
    func testGivenARecipeSelectedWhenUserTapToDeleteThenRecipeIsCorrectlyDeletedFromCoreData() {
        var fetchRecipes = [RecipeInformations]()
        // Deleting the object
        Delete.recipe(at: 0)
        // Fetching to implement test
        Fetch.recipe(into: &fetchRecipes)
        XCTAssertEqual(fetchRecipes.count, 0)
    }
}







