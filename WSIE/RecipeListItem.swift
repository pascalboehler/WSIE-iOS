//
//  RecipeListItemView.swift
//  WSIE
//
//  Created by Pascal Boehler on 23.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct RecipeListItem: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            Image(recipe.imageName)
                .resizable()
                .frame(height: 200)
                .clipped()

            Spacer()
            Text(recipe.title)
            HStack {
                Spacer()
                Text("For \(recipe.personAmount) person")
                Spacer()
                Image(systemName: "clock.fill")
                Text(recipe.timeNeeded)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing)
                Spacer()
            }
            Spacer()
        }
    }
}

struct RecipeListItem_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListItem(recipe: recipeData[0])
            .previewLayout(.fixed(width: 300, height: 270))
    }
}
