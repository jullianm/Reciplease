//
//  DetailedFavoritesRecipes.swift
//  Reciplease
//
//  Created by jullianm on 26/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class DetailedFavoritesRecipes: UIViewController {
 
    @IBOutlet weak var detailedFavoriteRecipeImage: UIImageView!
    @IBOutlet weak var detailedFavoriteRecipeName: UILabel!
    @IBOutlet weak var detailedFavoriteRecipeRating: UILabel!
    @IBOutlet weak var detailedFavoriteRecipeCookingTime: UILabel!
    @IBOutlet weak var detailedFavoriteRecipePortions: UITableView!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    
    var favoritesRecipes = [RecipeInformations]()
    var selectedFavoriteRecipeIndex = Int()
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        layer.locations = [0.7, 1]
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailedFavoriteRecipePortions.dataSource = self
        detailedFavoriteRecipeImage.layer.addSublayer(gradientLayer)
        gradientLayer.frame = detailedFavoriteRecipeImage.bounds
        self.title = "Reciplease"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = detailedFavoriteRecipeImage.bounds
    }
    @IBAction func deselectFromFavorites(_ sender: Any) {
        favoritesButton.tintColor = nil
        Delete.recipe(at: selectedFavoriteRecipeIndex)
    }
    @IBAction func getDirections(_ sender: UIButton) {
        let url = favoritesRecipes[selectedFavoriteRecipeIndex].instructions
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}
extension DetailedFavoritesRecipes: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesRecipes[selectedFavoriteRecipeIndex].portions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailed_favorite_portion") as! DetailedFavoritePortionCell
        cell.detailedFavoritePortion.text = "- " + favoritesRecipes[selectedFavoriteRecipeIndex].portions[indexPath.item]
        detailedFavoriteRecipeImage.image = UIImage(data:favoritesRecipes[selectedFavoriteRecipeIndex].image)
        detailedFavoriteRecipeName.text = favoritesRecipes[selectedFavoriteRecipeIndex].name
        detailedFavoriteRecipeRating.text = favoritesRecipes[selectedFavoriteRecipeIndex].rating
        detailedFavoriteRecipeCookingTime.text = favoritesRecipes[selectedFavoriteRecipeIndex].time
        return cell
    }
}
