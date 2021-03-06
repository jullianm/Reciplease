//
//  SecondViewController.swift
//  Reciplease
//
//  Created by jullianm on 13/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    
    @IBOutlet weak var favoritesRecipes: UITableView!
    var favoritesRecipesList = [RecipeInformations]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesRecipes.dataSource = self
        self.favoritesRecipes.delegate = self
        let name = Notification.Name(rawValue: "NoRecipesFound")
        NotificationCenter.default.addObserver(self, selector: #selector(displayMessage), name: name, object: nil)
    }
    @objc private func displayMessage() {
        let alertVC = UIAlertController(title: "No favorites recipes !", message: "Add a favorite recipe by selecting the star at the top right of the screen", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        Fetch.recipe(into: &favoritesRecipesList)
        favoritesRecipes.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        favoritesRecipesList = [RecipeInformations]()
    }
}
extension SecondViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesRecipesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite_cell") as! FavoritesCell

        cell.favoriteRecipeImage.image = UIImage(data: favoritesRecipesList[indexPath.item].image)
        cell.favoriteRecipeName.text = favoritesRecipesList[indexPath.item].name
        cell.favoriteRecipeIngredients.text = favoritesRecipesList[indexPath.item].ingredients
        cell.favoriteRecipeRating.text = favoritesRecipesList[indexPath.item].rating
        cell.favoriteRecipeCookingTime.text = favoritesRecipesList[indexPath.item].time
        return cell
    }
}
extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = storyboard?.instantiateViewController(withIdentifier: "detailedFavoritesRecipes") as! DetailedFavoritesRecipes
        destVC.favoritesRecipes = favoritesRecipesList
        destVC.selectedFavoriteRecipeIndex = indexPath.item
        show(destVC, sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.frame.height / 3
        return size
    }
}

