//
//  IngredientsListItem.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct IngredientsListItem: View {
    var ingredient: Ingredient
    
    var body: some View {
        HStack {
            Text(ingredient.amount)
            Spacer()
            Text(ingredient.name)
        }
        .padding(.horizontal)
    }
}

struct IngredientsListItem_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsListItem(ingredient: recipeData[0].ingredients[0])
    }
}
