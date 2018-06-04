//
//  Fetch.swift
//  Reciplease
//
//  Created by jullianm on 04/06/2018.
//  Copyright © 2018 jullianm. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Fetch {
    static func recipe(into recipesList: inout [RecipeInformations]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest) as! [Recipes]
            if results.count < 1 {
                let error = Notification.Name(rawValue: "NoRecipesFound")
                let notification = Notification(name: error)
                NotificationCenter.default.post(notification)
            } else {
                for result in results {
                    recipesList.append(RecipeInformations(name: result.name!, ingredients: result.ingredients!, portions: result.portions!, rating: result.rating!, time: result.cookingTime!, image: result.image!, instructions: result.instructions!))
                }
            }
        } catch {
            print(error)
        }
    }
}
