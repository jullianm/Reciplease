//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by jullianm on 17/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var recipes: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var request = FetchingRecipesList()
    var recipesList = [RecipeInformations]()

    override func viewDidLoad() {
        self.recipes.delegate = self
        self.recipes.dataSource = self
        createObservers()
    }
    
    func createObservers() {
        let recipes = Notification.Name(rawValue: "recipes")
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRecipes(notification:)),name: recipes, object: nil)
    }
    
@objc func receivedRecipes(notification: Notification) {

    if let data = notification.userInfo?["Data"] as? [RecipeInformations] {
        recipesList = data
        activity.isHidden = true
        recipes.reloadData()
    }
}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipe_cell") as! RecipeCell

        cell.separatorInset = UIEdgeInsets.zero
        
        cell.recipeName.text = recipesList[indexPath.item].name
        cell.recipeIngredientsName.text = recipesList[indexPath.item].ingredients
        cell.recipeCookingTime.text = recipesList[indexPath.item].time
        cell.recipeMark.text = recipesList[indexPath.item].rating

        let imageString = recipesList[indexPath.item].image
        let data = try? Data(contentsOf: imageString!)
        let image = UIImage(data: data!)
        cell.recipeImage.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.frame.height
        let count = recipesList.count
        return size / CGFloat(count) + 100
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = storyboard?.instantiateViewController(withIdentifier: "detailedRecipes") as? DetailedRecipesViewController
        destVC?.recipes = recipesList
        destVC?.selectedRecipe = indexPath.item
        show(destVC!, sender: self)
    }
    
}
