//
//  Delete.swift
//  Reciplease
//
//  Created by jullianm on 04/06/2018.
//  Copyright © 2018 jullianm. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Delete {
    static func recipe(at index: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest) as! [Recipes]
            if results.count > 0 {
                results.enumerated().forEach({ i, _ in
                    if index == i {
                        context.delete(results[index])
                    }
                })
            }
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
