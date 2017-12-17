//
//  FetchingRecipesList.swift
//  Reciplease
//
//  Created by jullianm on 14/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import Foundation
import Alamofire

class FetchingRecipesList {
    
    var searchForRecipesWithIngredients: [String] = []
    
    func recipesRequest(completion: @escaping ([RecipeInformations]) -> ()) {
        
        var recipeDetails = [RecipeInformations]()
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?")
        let HTTPHeaders: HTTPHeaders = ["X-Yummly-App-ID":"dda042d2","X-Yummly-App-Key":"6b4afceb278126620adba7ff792f8b86"]
        let parameters: Parameters = ["q": searchForRecipesWithIngredients, "maxResult": 20, "start": 20]
        
        DispatchQueue.global(qos: .userInteractive).async {
            
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: HTTPHeaders).responseData { (response) in
            guard let myData = response.result.value else { return }
            
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Root.self, from: myData)
                
                for i in root.matches {
                    
                    var recipeMark = String()
                    var cookingDuration = String()
                    if let rating = i.rating {
                        recipeMark = String(rating)
                    } else {
                        recipeMark = ""
                    }
                    if let cookingtime = i.totalTimeInSeconds {
                        let time = DateComponentsFormatter()
                        time.allowedUnits = [.hour, .minute]
                        time.unitsStyle = .abbreviated
                        cookingDuration = time.string(from: TimeInterval(cookingtime))!
                    } else {
                        cookingDuration = ""
                    }
                   
                    recipeDetails.append(RecipeInformations(id: i.id, ingredients: i.ingredients.joined(separator: ", ").capitalized, rating: recipeMark + "/5" , recipeName: i.recipeName, recipeImage: i.imageUrlsBySize["90"]!, cookingTime: cookingDuration))
                }

                DispatchQueue.main.async {
                    completion(recipeDetails)
                }
                
            } catch let error {
                print(error)
            }
        }
            
        }
    }
}
