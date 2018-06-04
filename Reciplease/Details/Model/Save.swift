//
//  Save.swift
//  Reciplease
//
//  Created by jullianm on 04/06/2018.
//  Copyright © 2018 jullianm. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Save {
    static func recipe(from recipes: [RecipeInformations], at index: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Recipes", in: context)
        let newRecipe = NSManagedObject(entity: entityDescription!, insertInto: context)
        newRecipe.setValue(recipes[index].name, forKey: "name")
        newRecipe.setValue(recipes[index].rating, forKey: "rating")
        newRecipe.setValue(recipes[index].time, forKey: "cookingTime")
        newRecipe.setValue(recipes[index].ingredients, forKey: "ingredients")
        newRecipe.setValue(recipes[index].instructions, forKey: "instructions")
        newRecipe.setValue(recipes[index].image, forKey: "image")
        newRecipe.setValue(recipes[index].portions, forKey: "portions")
        do {
            try newRecipe.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
}
