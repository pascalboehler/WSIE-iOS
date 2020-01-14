//
//  DataHelper.swift
//  WSIE
//
//  Created by Pascal Boehler on 14.01.20.
//  Copyright © 2020 Pascal Boehler. All rights reserved.
//

import Foundation

func convertIngredientsToAddIngredients(ingredients: [Ingredient]) -> [AddIngredient] {
    var addIngredients: [AddIngredient] = []
    for ingredient in ingredients {
        addIngredients.append(AddIngredient(id: ingredient.id, name: ingredient.name, amount: "\(ingredient.amount)", unit: ingredient.unit))
    }
    return addIngredients
}

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

