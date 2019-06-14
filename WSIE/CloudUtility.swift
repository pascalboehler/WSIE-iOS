//
//  CloudUtility.swift
//  WSIE
//
//  Created by Pascal Boehler on 09.06.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import Foundation
import Firebase

var recipeData: [Recipe] = []

func fetchRecipeData(db: Firestore) -> [Recipe] {
    
    var recipes = [Recipe]()
    // var recipe: Recipe
    
    db.collection("recipe").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            print("Fetched documents successfully")
            for document in querySnapshot!.documents {
                //print("\(document.documentID) => \(document.data())")
                //print(document.data()["title"] as! String)
                let recipe: Recipe = Recipe(title: document.data()["title"] as! String, shortDescription: document.data()["shortDescription"] as! String, cookingTime: document.data()["cookingTime"] as! Int, isFavourite: document.data()["isFavourite"] as! Bool, steps: document.data()["steps"] as! String, materials: document.data()["materials"] as! String, markDownCode: document.data()["md-code"] as! String)
                //print(recipe)
                recipes.append(recipe)
                //print(recipes)
            }
            //print(recipes)
            recipeData = recipes
            print(recipeData)
        }
    }
    
    // print(recipeData)
    return []
}
