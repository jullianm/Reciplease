//
//  DetailedFavoritesRecipes.swift
//  Reciplease
//
//  Created by jullianm on 26/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

class DetailedFavoritesRecipes: UIViewController, UITableViewDataSource {
 
    @IBOutlet weak var detailedFavoriteRecipeImage: UIImageView!
    @IBOutlet weak var detailedFavoriteRecipeName: UILabel!
    @IBOutlet weak var detailedFavoriteRecipeRating: UILabel!
    @IBOutlet weak var detailedFavoriteRecipeCookingTime: UILabel!
    @IBOutlet weak var detailedFavoriteRecipePortions: UITableView!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailedFavoriteRecipePortions.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailed_favorite_portion") as! DetailedFavoritePortionCell
        return cell
        
    }
    
    @IBAction func deselectFromFavorites(_ sender: Any) {
        favoritesButton.tintColor = nil
    }
}
