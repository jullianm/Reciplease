//
//  DetailedRecipesViewController.swift
//  Reciplease
//
//  Created by jullianm on 14/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

class DetailedRecipesViewController: UIViewController {

    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
