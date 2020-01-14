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
