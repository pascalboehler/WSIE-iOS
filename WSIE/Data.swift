//
//  Data.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseFirestore

// With local file:
var recipeData: [Recipe] = loadLocal("recipes.json")
fileprivate var db: Firestore!

func loadLocal<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

// fetch from server
func loadFirebase() {
    db.collection("recipes").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                print("\(document.documentID) => \(document.data())")
                recipeData.append(Recipe(id: data["id"] as! Int, title: data["title"] as! String, timeNeeded: data["timeNeeded"] as! String, isFavourite: data["isFavourite"] as! Bool, ingredients: data["ingredients"] as! [Ingredient], steps: data["steps"] as! [Step], shortDescription: data["shortDescription"] as! String, uid: data["userId"] as! String, imageName: data["imageName"] as! String, personAmount: data["personAmount"] as! Int, sharedWith: data["sharedWith"] as! [String], language: data["language"] as! String))
            }
        }
    }
}

func initFirebase() {
    // init firebase
    let settings = FirestoreSettings()
    Firestore.firestore().settings = settings
    db = Firestore.firestore()
}

func writeDummyData(recipe: Recipe) {
    // MARK: NOT WORKING!
    /*
    db.collection("recipes").document(recipe.title).setData([
        "id": recipe.id,
        "title": recipe.title,
        "timeNeeded": recipe.timeNeeded,
        "isFavourite": recipe.isFavourite,
        "ingredients": recipe.ingredients,
        "steps": recipe.steps,
        "uid": recipe.uid,
        "imageName": recipe.imageName,
        "personAmount": recipe.personAmount,
        "sharedWith": recipe.sharedWith,
        "language": recipe.language
        
    ])*/
}

func refreshData() {
    recipeData = loadFirebase()
}
