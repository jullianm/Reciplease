//
//  SecondViewController.swift
//  Reciplease
//
//  Created by jullianm on 13/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favoritesRecipes: UITableView!
    
    var favoritesRecipesList = [RecipesViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesRecipes.dataSource = self
        self.favoritesRecipes.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        fetchRecipes()
    }
    
    
    func fetchRecipes() {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest) as! [Recipes]
            for result in results {
                print(result)
            }
        } catch let error {
            print(error)
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite_cell") as! FavoritesCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = storyboard?.instantiateViewController(withIdentifier: "detailedFavoritesRecipes") as! DetailedFavoritesRecipes
        show(destVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.frame.height
        let count = 4
        return size / CGFloat(count) + 100
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

