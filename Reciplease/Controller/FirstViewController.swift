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
    
    var ingredients = [String]()
    var userDidTypeSomething: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientInput.delegate = self
        self.ingredientsList.dataSource = self
        let endEditing = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(endEditing)
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
    
    @IBAction func clearIngredients(_ sender: UITapGestureRecognizer) {
        ingredients = [String]()
        displayIngredientsExample()
        ingredientsList.reloadData()
    }
    
}

