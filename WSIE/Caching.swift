//
//  Caching.swift
//  WSIE
//
//  Created by Pascal Boehler on 14.01.20.
//  Copyright © 2020 Pascal Boehler. All rights reserved.
//

import Foundation

class Caching {
    // MARK: - Recipe
    func writeRecipeDataToCache(recipes: [Recipe]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(recipes)
            let path = URL(string: "recipe.json")!
            try data.write(to: path, options: .completeFileProtectionUntilFirstUserAuthentication)
        } catch {
            fatalError("Unable to load file from disk")
        }
    }
    
    func readRecipeDataFromCache() -> [Recipe] {
        let decoder = JSONDecoder()
        do {
            guard let url = URL(string: "recipe.json") else {
                print("Could'nt parse url")
                return []
            }
            let data = try Data(contentsOf: url)
            return try decoder.decode([Recipe].self, from: data)
        } catch {
            print("Unable to load data from disk!")
            return []
        }
    }
    
    // MARK: - Shopping List
    func writeShoppingListDataToCache(list: [ShoppingListItem]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(list)
            guard let path = URL(string: "shoppingList.json") else {
                print("Unable to encode url")
                return
            }
            try data.write(to: path, options: .completeFileProtectionUntilFirstUserAuthentication)
        } catch {
            fatalError("Unable to write data from disk!")
        }
    }

    func readShoppingListDataFromCache() -> [ShoppingListItem] {
        let decoder = JSONDecoder()
        do {
            guard let url = URL(string: "shoppingList.json") else {
                print("Unable to parse URL")
                return []
            }
            let data = try Data(contentsOf: url)
            return try decoder.decode([ShoppingListItem].self, from: data)
        } catch {
            return []
        }
    }
}
