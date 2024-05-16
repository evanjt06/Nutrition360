//
//  GenericFood.swift
//  Project17
//
//  Created by Evan Tu on 7/17/21.
//

import Foundation
import SwiftUI

struct GenericFood: Codable {
    var text: String
    var parsed: [GenericFood_Sub]?
    
    var hints: [GenericFood_Sub]?
}

struct GenericFood_Sub: Codable {
    var food: GenericFood_Sub2
}

struct GenericFood_Sub2: Codable {
    var label: String
    var nutrients: GenericFood_Nutrients
    var category: String
    var image: String?
}

struct GenericFood_Nutrients: Codable {
    var kcal: Double?
   var protein: Double?
   var fat: Double?
   var carbs: Double?
    var fiber: Double?

   private enum CodingKeys : String, CodingKey {
       case kcal = "ENERC_KCAL", protein = "PROCNT", fat="FAT", carbs="CHOCDF", fiber="FIBTG"
   }
}


class Api {
    func getFoods(food: String, completion: @escaping (GenericFood) -> ()) {
  
        var components = URLComponents()
           components.scheme = "https"
           components.host = "api.edamam.com"
           components.path = "/api/food-database/v2/parser"
           components.queryItems = [
               URLQueryItem(name: "app_id", value: "ec8aadf0"),
               URLQueryItem(name: "app_key", value: "b3932e88102eef7585f73bc9c03e400c"),
                URLQueryItem(name: "ingr", value: food),
            URLQueryItem(name: "nutrition-type", value: "cooking"),
           ]

           // Getting a URL from our components is as simple as
           // accessing the 'url' property.
           let url = components.url
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
        
            
            let ans = try! JSONDecoder().decode(GenericFood.self, from:  data!)
            
            DispatchQueue.main.async {
                completion(ans)
            }
        }
        .resume()
    }
    
    func getAutocompleteList(food: String, completion: @escaping ([String]) -> ()) {
        
        var components = URLComponents()
           components.scheme = "https"
           components.host = "api.edamam.com"
           components.path = "/auto-complete"
           components.queryItems = [
               URLQueryItem(name: "app_id", value: "ec8aadf0"),
               URLQueryItem(name: "app_key", value: "b3932e88102eef7585f73bc9c03e400c"),
                URLQueryItem(name: "q", value: food),
           ]

           // Getting a URL from our components is as simple as
           // accessing the 'url' property.
           let url = components.url
        
        URLSession.shared.dataTask(with: url!) { data, _, _ in
        
            let ans = try! JSONDecoder().decode([String].self, from:  data!)
            
            DispatchQueue.main.async {
                completion(ans)
            }
        }
        .resume()
    }
}
