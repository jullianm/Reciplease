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
    
    func recipesRequest() {
        
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?")
        let HTTPHeaders: HTTPHeaders = ["X-Yummly-App-ID":"dda042d2","X-Yummly-App-Key":"6b4afceb278126620adba7ff792f8b86"]
        let parameters: Parameters = ["q": searchForRecipesWithIngredients]
   
        DispatchQueue.global(qos: .userInteractive).async {
            
            Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: HTTPHeaders).responseData { (response) in
                guard let searchRecipesData = response.result.value else { return }
                
                self.getRecipes(searchRecipes: searchRecipesData)
            }
        }
    }
    
    func getRecipes(searchRecipes: Data) {
        
        var recipeDetails = [RecipeInformations]()
        
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
                            
                            var mark: String
                            var duration: String?
                            var finalImage: URL?

                            // Safely Unwrapping Recipe Rating
                            if let rating = match.rating {
                                mark = String(rating) + "/5"
                            } else {
                                mark = ""
                            }
                            
                            // Safely Unwrapping Recipe Cooking Time and Converting Value In Hours and Minutes
                            if let cookingtime = match.totalTimeInSeconds {
                                let time = DateComponentsFormatter()
                                time.allowedUnits = [.hour, .minute]
                                time.unitsStyle = .abbreviated
                                duration = time.string(from: TimeInterval(cookingtime))!
                            } else { duration = "" }
                            
                            // Safely Unwrapping Recipe Images
                            
                            if let images = detail.images {
                                for image in images {
                                    if let largeImage = image.hostedLargeUrl {
                                        finalImage = largeImage
                                    } else if let mediumImage = image.hostedMediumUrl {
                                        finalImage = mediumImage
                                    }
                                }
                            } else {
                                finalImage = URL(string:"http://i2.yummly.com/Hot-Turkey-Salad-Sandwiches-Allrecipes.l.png")
                            }
                            
                            // Appending each of our recipe object to the array
                            recipeDetails.append(RecipeInformations(name: match.recipeName, ingredients: match.ingredients.joined(separator: ", ").capitalized, portions: detail.ingredientLines, rating: mark, time: duration!, image: finalImage!, instructions: detail.source.sourceRecipeUrl))
                            
                            // when loop is finished, array is filled we recipes object thus we post a notification
                            
                            if recipeDetails.count == root.matches.count {
                                
                                let recipes = Notification.Name(rawValue: "recipes")
                                NotificationCenter.default.post(name: recipes, object: nil, userInfo: ["Data": recipeDetails])
                                
                            }
                        } catch {
                            let error = Notification.Name(rawValue: "Error")
                            let notification = Notification(name: error)
                            NotificationCenter.default.post(notification)
                        }
                    }
                }

            } catch {
                let error = Notification.Name(rawValue: "Error")
                let notification = Notification(name: error)
                NotificationCenter.default.post(notification)
            }
    }
}

