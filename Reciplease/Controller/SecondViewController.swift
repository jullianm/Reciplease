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
    
    var favoritesRecipesList = [RecipeInformations]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesRecipes.dataSource = self
        self.favoritesRecipes.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        fetchFavoritesRecipes()
        favoritesRecipes.reloadData()
    }
    
    func fetchFavoritesRecipes() {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest) as! [Recipes]
            
            if results.count < 1 {
                let alertVC = UIAlertController(title: "No favorites recipes !", message: "Add a favorite recipe by selecting the star at the top right of the screen", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                
            } else {
            for result in results {
                favoritesRecipesList.append(RecipeInformations(name: result.name!, ingredients: result.ingredients!, portions: result.portions!, rating: result.rating!, time: result.cookingTime!, image: result.image!, instructions: result.instructions!))
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesRecipesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite_cell") as! FavoritesCell
        
        let imageString = favoritesRecipesList[indexPath.item].image
        let data = try? Data(contentsOf: imageString)
        let image = UIImage(data: data!)
        cell.favoriteRecipeImage.image = image
        cell.favoriteRecipeName.text = favoritesRecipesList[indexPath.item].name
        cell.favoriteRecipeIngredients.text = favoritesRecipesList[indexPath.item].ingredients
        cell.favoriteRecipeRating.text = favoritesRecipesList[indexPath.item].rating
        cell.favoriteRecipeCookingTime.text = favoritesRecipesList[indexPath.item].time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = storyboard?.instantiateViewController(withIdentifier: "detailedFavoritesRecipes") as! DetailedFavoritesRecipes
        destVC.favoritesRecipes = favoritesRecipesList
        destVC.selectedFavoriteRecipe = indexPath.item
        show(destVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.frame.height / 3
        return size 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        favoritesRecipesList = [RecipeInformations]()
    }
}

