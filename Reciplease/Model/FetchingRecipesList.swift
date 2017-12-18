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
    var recipeDetails = [RecipeInformations]()
    
    func recipesRequest() {
        
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?")
        let HTTPHeaders: HTTPHeaders = ["X-Yummly-App-ID":"dda042d2","X-Yummly-App-Key":"6b4afceb278126620adba7ff792f8b86"]
        let parameters: Parameters = ["q": searchForRecipesWithIngredients, "maxResult": 20, "start": 20]
   
        DispatchQueue.global(qos: .userInteractive).async {
            
            Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: HTTPHeaders).responseData { (response) in
                guard let searchRecipesData = response.result.value else { return }
                
                self.getRecipes(searchRecipes: searchRecipesData)
            }
        }
  
    }
    
    func getRecipes(searchRecipes: Data) {
        
        let parameters: Parameters = ["_app_id":"dda042d2","_app_key":"6b4afceb278126620adba7ff792f8b86"]
            
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Root.self, from: searchRecipes)
                
                for match in root.matches {
            
                    let url = URL(string: "http://api.yummly.com/v1/api/recipe/\(match.id+"?")")
                    
                    Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseData { (response) in
                        
                        guard let getRecipeData = response.result.value else { return }
                        
                        do {
                            
                        let detail = try decoder.decode(GetRecipesRoot.self, from: getRecipeData)
                            
                            var mark = String()
                            var duration = String()
                            var largeImage = String()

                            if let rating = match.rating { mark = String(rating) } else { mark = "" }
                            if let cookingtime = match.totalTimeInSeconds {
                                let time = DateComponentsFormatter()
                                time.allowedUnits = [.hour, .minute]
                                time.unitsStyle = .abbreviated
                                duration = time.string(from: TimeInterval(cookingtime))!
                            } else { duration = "" }
                            
                            for image in detail.images {
                                largeImage = image.hostedLargeUrl
                            }

                            self.recipeDetails.append(RecipeInformations(name: match.recipeName, ingredients: match.ingredients.joined(separator: ", "), portions: detail.ingredientLines.joined(separator: ", "), rating: mark, time: duration, image: largeImage))
          
                            if self.recipeDetails.count == root.matches.count {
                                
                                let recipes = Notification.Name(rawValue: "gotRecipes")
                                let notification = Notification(name: recipes)
                                NotificationCenter.default.post(notification)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }

            } catch {
                print(error)
            }
        
    }
}

