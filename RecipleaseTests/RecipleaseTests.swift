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
     func testGivenARecipeSelectedWhenUserAddToFavoriteThenRecipeIsAddedToCoreData() {
        let context = getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Recipes", in: context)
        let newRecipe = NSManagedObject(entity: entityDescription!, insertInto: context)
        var name = String()
        newRecipe.setValue("Testing CoreData", forKey: "name")
        do {
            try newRecipe.managedObjectContext?.save()
        } catch {
            print(error)
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest) as! [Recipes]
            for result in results {
                name = result.name!
            }
        } catch {
            print(error)
        }
        XCTAssertEqual(name, "Testing CoreData" , "Core Data not working")
    }
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}







