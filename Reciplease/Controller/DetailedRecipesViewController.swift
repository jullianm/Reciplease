//
//  DetailedRecipesViewController.swift
//  Reciplease
//
//  Created by jullianm on 14/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit
import SafariServices
import CoreData

class DetailedRecipesViewController: UIViewController {

    @IBOutlet weak var recipeCookingTime: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var detailedPortions: UITableView!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var recipes = [RecipeInformations]()
    var selectedRecipe = Int()
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
        self.detailedPortions.dataSource = self
        recipeImage.layer.addSublayer(gradientLayer)
        gradientLayer.frame = recipeImage.bounds
    }
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = recipeImage.bounds
    }
    
    @IBAction func didTapFavorites(_ sender: UITapGestureRecognizer) {
        favoritesButton.tintColor = #colorLiteral(red: 0.2673686743, green: 0.5816780329, blue: 0.3659712374, alpha: 1)
        let context = getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Recipes", in: context)
        let newRecipe = NSManagedObject(entity: entityDescription!, insertInto: context)
        newRecipe.setValue(recipes[selectedRecipe].name, forKey: "name")
        newRecipe.setValue(recipeRating.text, forKey: "rating")
        newRecipe.setValue(recipeCookingTime.text, forKey: "cookingTime")
        newRecipe.setValue(recipes[selectedRecipe].ingredients, forKey: "ingredients")
        newRecipe.setValue(recipes[selectedRecipe].instructions, forKey: "instructions")
        newRecipe.setValue(recipes[selectedRecipe].image, forKey: "image")
        newRecipe.setValue(recipes[selectedRecipe].portions, forKey: "portions")
        do {
            try newRecipe.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    @IBAction func getDirections(_ sender: UIButton) {
        let url = recipes[selectedRecipe].instructions
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}
extension DetailedRecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes[selectedRecipe].portions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailed_portion") as! DetailedPortionCell
        let imageString = recipes[selectedRecipe].image
        let data = try? Data(contentsOf: imageString)
        let imageToDisplay = UIImage(data: data!)
        cell.portion.text = "- " + recipes[selectedRecipe].portions[indexPath.item]
        recipeImage.image = imageToDisplay
        recipeName.text = recipes[selectedRecipe].name
        recipeRating.text = recipes[selectedRecipe].rating
        recipeCookingTime.text = recipes[selectedRecipe].time
        return cell
    }
}
