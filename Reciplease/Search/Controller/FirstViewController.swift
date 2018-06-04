//
//  FirstViewController.swift
//  Reciplease
//
//  Created by jullianm on 13/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
  
    @IBOutlet weak var ingredientInput: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchForRecipes: UIButton!
    @IBOutlet weak var ingredientsList: UITableView!
    
    var request = FetchingRecipesList()
    var ingredients = [String]()
    var userDidTypeSomething: Bool = false
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientInput.resignFirstResponder()
        if ingredientInput.text == "" {
        displayIngredientsExample()
        }
    }
    func displayIngredientsExample() {
        ingredientInput.text = "Lemon, Cheese, Sausages.."
    }
    @IBAction func addIngredient(_ sender: UITapGestureRecognizer) {
        let ingredientsExample = "Lemon, Cheese, Sausages.."
        let userInput = ingredientInput.text
        let trimmedUserInput = userInput?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        ingredientInput.resignFirstResponder()
        if (userInput != ingredientsExample) && (!(trimmedUserInput?.isEmpty)!) && (!ingredients.contains(userInput!))  {
            ingredients.append(userInput!)
            ingredientsList.reloadData()
        }
        displayIngredientsExample()
    }
    @IBAction func clearIngredients(_ sender: UITapGestureRecognizer) {
        ingredientInput.resignFirstResponder()
        ingredients = [String]()
        displayIngredientsExample()
        ingredientsList.reloadData()
    }
    @IBAction func searchForRecipes(_ sender: UITapGestureRecognizer) {
        if !ingredients.isEmpty {
            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "recipesList") as? RecipesViewController
            FetchingRecipesList.getRecipes(ingredients: ingredients) { recipes in
                destVC?.recipesList = recipes
                destVC?.canReloadData = true
            }
            self.show(destVC!, sender: self)
        }
    }
}
extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredient_cell") as! IngredientCell
        cell.ingredientName.text = "- " + ingredients[indexPath.item]
        return cell
    }
}

extension FirstViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientsList.dataSource = self
        let endEditing = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(endEditing)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillLayoutSubviews() {
        addButton.layer.cornerRadius = 5.0
        clearButton.layer.cornerRadius = 5.0
        searchForRecipes.layer.cornerRadius = 5.0
        ingredientInput.borderStyle = .none
        ingredientInput.layer.backgroundColor = UIColor.white.cgColor
        ingredientInput.layer.masksToBounds = false
        ingredientInput.layer.shadowColor = UIColor.gray.cgColor
        ingredientInput.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ingredientInput.layer.shadowOpacity = 1.0
        ingredientInput.layer.shadowRadius = 0.0
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
