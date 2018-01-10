//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by jullianm on 13/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipleaseTests: XCTestCase {
    
    var fetchingRecipesList: FetchingRecipesList!
    var recipesVC: RecipesViewController!
    
    override func setUp() {
        super.setUp()
        fetchingRecipesList = FetchingRecipesList()
        recipesVC = RecipesViewController()
    }
    
    override func tearDown() {
        super.tearDown()
        fetchingRecipesList = nil
        recipesVC = nil
    }
    
    func testGivenAnIngredientInputWhenFetchingRecipesListIsCalledThenWeGetRecipesDetails() {
        
        // 1. Given
        fetchingRecipesList.searchForRecipesWithIngredients = ["Strawberry"]
        
        // 2. When
        
        fetchingRecipesList.recipesRequest()
        
        // 3. Then

    }
}
