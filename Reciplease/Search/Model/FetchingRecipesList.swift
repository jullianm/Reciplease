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
    static func getRecipes(ingredients: [String], completion: @escaping ([RecipeInformations]) -> ()) {
        var recipeDetails = [RecipeInformations]()
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?")
        let HTTPHeaders: HTTPHeaders = ["X-Yummly-App-ID":"dda042d2","X-Yummly-App-Key":"6b4afceb278126620adba7ff792f8b86"]
        let firstParameters: Parameters = ["q": ingredients, "maxResult": 20]
        let secondParameters: Parameters = ["_app_id":"dda042d2","_app_key":"6b4afceb278126620adba7ff792f8b86"]
        let decoder = JSONDecoder()
        DispatchQueue.global(qos: .userInteractive).async {
            Alamofire.request(url!, method: .get, parameters: firstParameters, encoding: URLEncoding.default, headers: HTTPHeaders).responseData { (response) in()
                guard let searchRecipesData = response.result.value else { return }
                do {
                    let root = try decoder.decode(Root.self, from: searchRecipesData)
                    if root.matches.isEmpty {
                        displayErrorMessage()
                        completion([])
                    } else {
                        for match in root.matches {
                            let url = URL(string: "http://api.yummly.com/v1/api/recipe/\(match.id+"?")")
                            Alamofire.request(url!, method: .get, parameters: secondParameters, encoding: URLEncoding.queryString, headers: nil).responseData { (response) in
                            guard let getRecipeData = response.result.value else { return }
                                do {
                                    let detail = try decoder.decode(GetRecipesRoot.self, from: getRecipeData)
                                    // Creating our recipes objects
                                    recipeDetails.append(RecipeInformations(name: match.recipeName, ingredients: match.ingredients.joined(separator: ", ").capitalized, portions: detail.ingredientLines, rating: getRating(from: match), time: getCookTime(from: match), image: getImage(from: detail), instructions: detail.source.sourceRecipeUrl))
                                    } catch {
                                        displayErrorMessage()
                                    }
                                    if root.matches.count == recipeDetails.count {
                                        completion(recipeDetails)
                                    }
                                }
                            }
                    }
                } catch {
                    displayErrorMessage()
                }
            }
        }
        // Helpers methods
        func getRating(from root: Matches) -> String {
            guard let rating = root.rating else { return "" }
            return String(rating) + "/5"
        }
        func getCookTime(from root: Matches) -> String {
            guard let cookingTime = root.totalTimeInSeconds else { return "" }
            let time = DateComponentsFormatter()
            time.allowedUnits = [.hour, .minute]
            time.unitsStyle = .abbreviated
            return time.string(from: TimeInterval(cookingTime))!

        }
         func getImage(from root: GetRecipesRoot) -> Data {
            if let imagesURL = root.images {
                for imageURL in imagesURL {
                    if let largeImageURL = imageURL.hostedLargeUrl, let imageData = try? Data(contentsOf: largeImageURL) {
                        return imageData
                    } else if let mediumImageURL = imageURL.hostedMediumUrl, let imageData = try? Data(contentsOf: mediumImageURL) {
                        return imageData
                    }
                }
            }
            return try! Data(contentsOf: URL(string:"http://i2.yummly.com/Hot-Turkey-Salad-Sandwiches-Allrecipes.l.png")!)
        }
        func displayErrorMessage() {
            let error = Notification.Name(rawValue: "Error")
            let notification = Notification(name: error)
            NotificationCenter.default.post(notification)
        }
    }
}
