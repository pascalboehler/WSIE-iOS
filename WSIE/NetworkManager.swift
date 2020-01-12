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
import Alamofire
import SwiftyJSON

// With local file:
//var recipeData: [Recipe] = loadLocal("recipes.json")
// from server
var recipeData: [Recipe] = loadFromApi()
var shoppingListTestData: [ShoppingListItem] = loadLocal("shoppingListItems.json")
let urlPrefix: String = "http://wsiedevapi.uksouth.cloudapp.azure.com"

//fileprivate var db: Firestore!

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

func loadFromApi() -> [Recipe] {
    var recipes: [Recipe] = []
    //let urlString = "http://localhost:8080/recipe/UID/\(Auth.auth().currentUser!.uid)"
    
    let urlString = "\(urlPrefix)/recipe" // receive all public elements => for testing
    guard let url = URL(string: urlString) else {
        return []
    }
    Alamofire.request(url, method: .get).validate().responseData { response in
        guard response.result.isSuccess else {
            print("ERROR WHILE FETCHING DATA")
            return
        }
        do {
            let decoder = JSONDecoder()
            try recipes =  decoder.decode([Recipe].self, from: response.result.value!)
        } catch {
            fatalError("Couldn't parse \(url) as \([Recipe].self):\n\(error)")
        }
    }
    print(recipes)
    return recipes
}

class NetworkManager : ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var shoppingList: [ShoppingListItem] = []
    @Published var isLoadingRecipes: Bool = false
    @Published var isLoadingList: Bool = false
    
    init() {
        if Auth.auth().currentUser != nil {
            loadRecipesFromApi()
            loadShoppingListFromApi()
        }
    }
    
    private func loadRecipesFromApi() {
        print("Fetching started...")
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let urlString = "\(urlPrefix)/recipe/uid/\(uid)" // receive all public elements => for testing
        guard let url = URL(string: urlString) else {
            print("WRONG URL")
            return
        }
        Alamofire.request(url, method: .get).validate().responseData { response in
            guard response.result.isSuccess else {
                print("ERROR WHILE FETCHING RECIPE DATA")
                return
            }
            do {
                let decoder = JSONDecoder()
                try self.recipes =  decoder.decode([Recipe].self, from: response.result.value!)
                self.isLoadingRecipes = false
                print("fetch completed")
            } catch {
                fatalError("Couldn't parse \(url) as \([Recipe].self):\n\(error)")
            }
        }
    }
    
    private func loadShoppingListFromApi() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let urlString = "\(urlPrefix)/shoppingList/uid/\(uid)" // receive all test elements => only for testing!
        guard let url = URL(string: urlString) else {
            print("WRONG URL")
            return
        }
        Alamofire.request(url, method: .get).validate().responseData { response in
            guard response.result.isSuccess else {
                print("ERROR WHILE FETCHING SHOPPING LIST DATA")
                return
            }
            do {
                let decoder = JSONDecoder()
                try self.shoppingList =  decoder.decode([ShoppingListItem].self, from: response.result.value!)
                self.isLoadingList = false
            } catch {
                fatalError("Couldn't parse \(url) as \([ShoppingListItem].self):\n\(error)")
            }
        }
    }
    
    func updateShoppingListItem(itemId: Int, updatedItem: ShoppingListItem) {
        var i = 0
        for item in shoppingList {
            if item.id! == itemId {
                shoppingList[i] = updatedItem
                do {
                    let encoder = JSONEncoder()
                    guard let params = try JSON(data: encoder.encode(shoppingList[i])).dictionaryObject else {
                        fatalError("Unable to open dict")
                    }
                    let urlString = "\(urlPrefix)/shoppingList"
                    guard let url = URL(string: urlString) else {
                        fatalError("Wrong URL format")
                    }
                    Alamofire.request(url, method: .post, parameters: params as Parameters, encoding: JSONEncoding.default).validate()
                } catch {
                    fatalError("Unable to update shopping list")
                }
            }
            i += 1
        }
    }
    
    func updateRecipeItem(itemId: Int, updatedRecipe: Recipe) {
        var i = 0
        for recipe in recipes {
            if recipe.id! == itemId {
                recipes[i] = updatedRecipe
                do {
                    let encoder = JSONEncoder()
                    guard let params = try JSON(data: encoder.encode(updatedRecipe)).dictionaryObject else {
                        fatalError("Unable to open dict")
                    }
                    let urlString = "\(urlPrefix)/recipe"
                    guard let url = URL(string: urlString) else {
                        fatalError("Wrong URL format")
                    }
                    Alamofire.request(url, method: .post, parameters: params as Parameters, encoding: JSONEncoding.default).validate()
                } catch {
                    fatalError("Unable to update object")
                }
            }
            i += 1
        }
    }
    
    func deleteRecipe(recipeId: Int) {
        do {
            let encoder = JSONEncoder()
            guard let params = try JSON(data: encoder.encode(recipes[recipeId])).dictionaryObject else {
                fatalError("Unable to open dict")
            }
            //let params = convertRecipeToList(recipe: recipes[recipeId])
            let urlString = "\(urlPrefix)/recipe"
            guard let url = URL(string: urlString) else {
                fatalError("Wrong URL format")
            }
            Alamofire.request(url, method: .delete, parameters: params as Parameters, encoding: JSONEncoding.default).validate()
        } catch {
            fatalError("Unable to parse JSON")
        }
    }
    
    func createNewShoppingListItemFromIngredient(ingredient: Ingredient) {
        let item = ShoppingListItem(itemTitle: ingredient.name, itemAmount: ingredient.amount, itemUnit: ingredient.unit, isCompleted: false, uid: Auth.auth().currentUser!.uid)
        let encoder = JSONEncoder()
        do {
            guard let params = try JSON(data: encoder.encode(item)).dictionaryObject else {
                fatalError("Unable to create dict")
            }
            let urlString = "\(urlPrefix)/shoppingList"
            guard let url = URL(string: urlString) else {
                fatalError("Wrong URL format")
            }
            Alamofire.request(url, method: .post, parameters: params as Parameters, encoding: JSONEncoding.default).validate()
        } catch {
            fatalError("Unable to parse JSON")
        }
    }
    
    func createNewRecipe(recipe: Recipe) {
        let encoder = JSONEncoder()
        do {
            guard let params = try JSON(data: encoder.encode(recipe)).dictionaryObject else {
                fatalError("Unable to create dict")
            }
            let urlString = "\(urlPrefix)/recipe"
            guard let url = URL(string: urlString) else {
                fatalError("Wrong URL format!")
            }
            print(recipe)
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate()
        } catch {
            fatalError("Unable to parse JSON")
        }
    }
    
    func reloadRecipeData() {
        loadRecipesFromApi()
    }
    
    func reloadShoppingListData() {
        loadShoppingListFromApi()
    }
    
    func reloadAll() {
        loadRecipesFromApi()
        loadShoppingListFromApi()
    }
}
