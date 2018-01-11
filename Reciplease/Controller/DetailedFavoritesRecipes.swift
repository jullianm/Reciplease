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
    var selectedFavoriteRecipe = Int()
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
    }
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = detailedFavoriteRecipeImage.bounds
    }
    @IBAction func deselectFromFavorites(_ sender: Any) {
        favoritesButton.tintColor = nil
        deleteObject()
    }
    func deleteObject() {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        do {
            let results = try context.fetch(fetchRequest) as! [Recipes]
                context.delete(results[selectedFavoriteRecipe])
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    @IBAction func getDirections(_ sender: UIButton) {
        let url = favoritesRecipes[selectedFavoriteRecipe].instructions
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}
extension DetailedFavoritesRecipes: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesRecipes[selectedFavoriteRecipe].portions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailed_favorite_portion") as! DetailedFavoritePortionCell
        cell.detailedFavoritePortion.text = "- " + favoritesRecipes[selectedFavoriteRecipe].portions[indexPath.item]
        detailedFavoriteRecipeImage.image = UIImage(data:favoritesRecipes[selectedFavoriteRecipe].image)
        detailedFavoriteRecipeName.text = favoritesRecipes[selectedFavoriteRecipe].name
        detailedFavoriteRecipeRating.text = favoritesRecipes[selectedFavoriteRecipe].rating
        detailedFavoriteRecipeCookingTime.text = favoritesRecipes[selectedFavoriteRecipe].time
        return cell
    }
}
