//
//  DetailedRecipesViewController.swift
//  Reciplease
//
//  Created by jullianm on 14/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

class DetailedRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipeCookingTime: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var detailedPortions: UITableView!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var recipes = [RecipeInformations]()
    var selectedRecipe = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailedPortions.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes[selectedRecipe].portions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailed_portion") as! DetailedPortionCell
        cell.portion.text = "- " + recipes[selectedRecipe].portions[indexPath.item]
        
        let imageString = recipes[selectedRecipe].image
        let data = try? Data(contentsOf: imageString!)
        let imageToDisplay = UIImage(data: data!)
        recipeImage.image = imageToDisplay
        recipeName.text = recipes[selectedRecipe].name
        recipeRating.text = recipes[selectedRecipe].rating
        recipeCookingTime.text = recipes[selectedRecipe].time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.frame.height / CGFloat(recipes[selectedRecipe].portions.count)
        return size
    }
    
    @IBAction func didTapFavorites(_ sender: UITapGestureRecognizer) {
        if favoritesButton.tintColor == #colorLiteral(red: 0.2673686743, green: 0.5816780329, blue: 0.3659712374, alpha: 1) {
            favoritesButton.tintColor = nil
        } else {
            favoritesButton.tintColor = #colorLiteral(red: 0.2673686743, green: 0.5816780329, blue: 0.3659712374, alpha: 1)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }

}
