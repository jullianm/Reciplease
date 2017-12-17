//
//  JSONDataModel.swift
//  Reciplease
//
//  Created by jullianm on 15/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import Foundation

// MARK:- Decoding weather

struct Root : Decodable {
    let matches : [Matches]
}

struct Matches : Decodable {
    let ingredients: [String]
    let rating: Int?
    let recipeName: String
    let imageUrlsBySize: [String:URL]
    let id: String
    let totalTimeInSeconds: Int?
}





