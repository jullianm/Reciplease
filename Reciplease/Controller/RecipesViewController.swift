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
    var canReloadData = false {
        didSet {
            if canReloadData {
                activity.stopAnimating()
                recipes.reloadData()
            }
        }
    }
    let error = Notification.Name(rawValue: "Error")
    var isFirstLoad = [Int:Bool]()
    
    override func viewDidLoad() {
        self.recipes.delegate = self
        self.recipes.dataSource = self
        self.title = "Reciplease"
        NotificationCenter.default.addObserver(self, selector: #selector(displayErrorAlert), name: error, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
// MARK:- Methods
@objc func displayErrorAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Couldn't retrieve data from server", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    self.present(alertVC, animated: true, completion: nil)
    
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
        cell.recipeImage.image = UIImage(data: recipesList[indexPath.item].image)
        return cell
    }
}
extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.frame.height / 3
        return size
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isFirstLoad[indexPath.item] != false {
            cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.allowUserInteraction], animations: {
                cell.transform = .identity
            }, completion: nil)
        }
        isFirstLoad.updateValue(false, forKey: indexPath.item)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = storyboard?.instantiateViewController(withIdentifier: "detailedRecipes") as? DetailedRecipesViewController
        destVC?.recipes = recipesList
        destVC?.selectedRecipe = indexPath.item
        show(destVC!, sender: self)
        }
    }
