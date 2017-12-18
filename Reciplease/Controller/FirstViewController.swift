//
//  FirstViewController.swift
//  Reciplease
//
//  Created by jullianm on 13/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ingredientInput: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchForRecipes: UIButton!
    @IBOutlet weak var ingredientsList: UITableView!
    
    var request = FetchingRecipesList()
    var ingredients = [String]()
    var userDidTypeSomething: Bool = false
    var recipes = [RecipeInformations]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ingredientInput.delegate = self
        self.ingredientsList.dataSource = self
        let endEditing = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(endEditing)
        let recipes = Notification.Name(rawValue: "gotRecipes")
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRecipes),name: recipes, object: nil)
    }
    
    @objc func receivedRecipes() {
        recipes = request.recipeDetails
        print(recipes)
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
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientInput.resignFirstResponder()
        if ingredientInput.text == "" {
        displayIngredientsExample()
        }
    }
    
    func displayIngredientsExample() {
        ingredientInput.text = "Lemon, Cheese, Sausages.."
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredient_cell") as! IngredientCell
        cell.ingredientName.text = "- " + ingredients[indexPath.item]
        return cell
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func clearIngredients(_ sender: UITapGestureRecognizer) {
        ingredientInput.resignFirstResponder()
        ingredients = [String]()
        displayIngredientsExample()
        ingredientsList.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        request.recipesRequest()        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !ingredients.isEmpty {
            self.request.searchForRecipesWithIngredients = self.ingredients
            return true
        }
        return false
    }
}

