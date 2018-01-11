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
    private func getRecipes(searchRecipes: Data) {
        
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
                            var rating: String {
                                return self.unwrappingRatingFromJSON(jsonData: match)
                            }
                            var duration: String {
                                return self.unwrappingCookingTimeFromJSON(jsonData: match)
                            }
                            var finalImageURL: URL? {
                                return self.unwrappingURLFromJSON(jsonData: detail)
                            }
                           
                            self.convertURLToData(myURL: finalImageURL!, completion: { data in
                                
                                recipeDetails.append(RecipeInformations(name: match.recipeName, ingredients: match.ingredients.joined(separator: ", ").capitalized, portions: detail.ingredientLines, rating: rating, time: duration, image: data, instructions: detail.source.sourceRecipeUrl))
                                
                                if recipeDetails.count == root.matches.count {
                                    let recipes = Notification.Name(rawValue: "recipes")
                                    NotificationCenter.default.post(name: recipes, object: nil, userInfo: ["Data": recipeDetails])
                                }
                            })
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
    
    private func unwrappingRatingFromJSON(jsonData: Matches) -> String {
        
        if let rating = jsonData.rating {
            return String(rating) + "/5"
        } else {
            return ""
        }
    }
    
    private func unwrappingCookingTimeFromJSON(jsonData: Matches) -> String {
        if let cookingtime = jsonData.totalTimeInSeconds {
            let time = DateComponentsFormatter()
            time.allowedUnits = [.hour, .minute]
            time.unitsStyle = .abbreviated
            return time.string(from: TimeInterval(cookingtime))!
        } else {
            return ""
        }
    }
    
    private func unwrappingURLFromJSON(jsonData: GetRecipesRoot) -> URL {
        if let imagesURL = jsonData.images {
            for imageURL in imagesURL {
                if let largeImageURL = imageURL.hostedLargeUrl {
                    return largeImageURL
                } else if let mediumImageURL = imageURL.hostedMediumUrl {
                    return mediumImageURL
                }
            }
            }
        return URL(string:"http://i2.yummly.com/Hot-Turkey-Salad-Sandwiches-Allrecipes.l.png")!
        }
    
    private func convertURLToData(myURL: URL, completion: @escaping (Data) -> ()) {
        Alamofire.request(myURL).responseData { response in
            guard let myData = response.result.value else { return }
            completion(myData)
        }
    }
}
