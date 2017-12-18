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
    var recipesList = [RecipeInformations]()
    var whichFrame: CGRect?
    
    override func viewDidLoad() {
        self.recipes.delegate = self
        self.recipes.dataSource = self
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipe_cell") as! RecipeCell
        whichFrame = cell.frame
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.recipeName.text = recipesList[indexPath.item].name
//        cell.recipeIngredientsName.text = recipesList[indexPath.item].ingredients
//        cell.recipeCookingTime.text = recipesList[indexPath.item].time
//        cell.recipeMark.text = recipesList[indexPath.item].rating
//
//        let imageString = recipesList[indexPath.item].image
//        let data = try? Data(contentsOf: imageString)
//        let image = UIImage(data: data!)
//        cell.recipeImage.image = image
        
        
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
    
}
