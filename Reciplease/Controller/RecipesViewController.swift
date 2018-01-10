//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by jullianm on 17/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {
    
// MARK:- Properties
    @IBOutlet weak var recipes: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var request = FetchingRecipesList()
    var recipesList = [RecipeInformations]()
    let receivedRecipes = Notification.Name(rawValue: "recipes")
    let error = Notification.Name(rawValue: "Error")
    
    override func viewDidLoad() {
        self.recipes.delegate = self
        self.recipes.dataSource = self
        createObservers()
    }
    
// MARK:- Methods
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRecipes(notification:)),name: receivedRecipes, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayErrorAlert), name: error, object: nil)
    }
@objc func displayErrorAlert() {
    
        let alertVC = UIAlertController(title: "Error", message: "Couldn't retrieve data from server", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    self.present(alertVC, animated: true, completion: nil)
    
    }
@objc func receivedRecipes(notification: Notification) {

    if let data = notification.userInfo?["Data"] as? [RecipeInformations] {
        recipesList = data
        activity.isHidden = true
        recipes.reloadData()
    }
}
}
// MARK: Extensions
extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipe_cell") as! RecipeCell
        cell.recipeName.text = recipesList[indexPath.item].name
        cell.recipeIngredientsName.text = recipesList[indexPath.item].ingredients
        cell.recipeCookingTime.text = recipesList[indexPath.item].time
        cell.recipeMark.text = recipesList[indexPath.item].rating
        let imageString = recipesList[indexPath.item].image
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageString)
            DispatchQueue.main.async {
        cell.recipeImage.image = UIImage(data: data!)
            }
        }
        return cell
    }
}
extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.frame.height / 3
        return size
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = storyboard?.instantiateViewController(withIdentifier: "detailedRecipes") as? DetailedRecipesViewController
        destVC?.recipes = recipesList
        destVC?.selectedRecipe = indexPath.item
        show(destVC!, sender: self)
        }
    }
