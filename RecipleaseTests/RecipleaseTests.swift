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
    
    func testGivenAnIngredientInputWhenFetchingRecipesListIsCalledThenWeGetRecipesObjects() {
        let expectations = expectation(description: "Retrieved recipes from API")
        let ingredients = ["Ham", "Onion"]
        FetchingRecipesList.getRecipes(ingredients: ingredients) { recipes in
            XCTAssertFalse(recipes.isEmpty)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    func testGivenAnUnknownIngredientInputWhenFetchingRecipesListIsCalledThenWeDontGetAnyObjects() {
        let expectations = expectation(description: "Error, no data found")
        let ingredients = ["aWrongIngredienThatDoesntEvenExist"]
        FetchingRecipesList.getRecipes(ingredients: ingredients) { recipes in
            XCTAssertTrue(recipes.isEmpty)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // Testing CoreData objects - Save and fetch
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
    // Delete
    func testGivenARecipeSelectedWhenUserTapToDeleteThenRecipeIsCorrectlyDeletedFromCoreData() {
        var fetchRecipes = [RecipeInformations]()
        // Deleting the object
        Delete.recipe(at: 0)
        // Fetching to implement test
        Fetch.recipe(into: &fetchRecipes)
        XCTAssertEqual(fetchRecipes.count, 0)
    }
}







