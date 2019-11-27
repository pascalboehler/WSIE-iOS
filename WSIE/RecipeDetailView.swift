//
//  RecipeDetailView.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    var body: some View {
        ScrollView {
            Group { // Image
                Image(recipe.imageName)
                    .resizable()
                    .cornerRadius(CGFloat(25))
                    .aspectRatio(3/2, contentMode: .fit)
                    
                Divider()
            }
            Group { // Person Amount and needed Cookingtime
                HStack {
                    Text("For \(recipe.personAmount) person")
                        .font(Font.system(size: 12))
                    Spacer()
                    Image(systemName: "clock")
                    Text(recipe.timeNeeded)
                        .font(Font.system(size: 12))
                }
                Divider()
            }
            
            Group { // Short description
                Text(recipe.shortDescription)
                    .font(Font.system(size: 14))
                    .multilineTextAlignment(.leading)
                Divider()
            }
            
            Group { // Materials
                HStack {
                    Text("Materials needed:")
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    Button(action: {
                        print("Delete button tapped!")
                    }) {
                        Image(systemName: "cart.badge.plus")
                        Text("Add to list")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                }
                Divider()
                ForEach(recipe.ingredients) { ingredient in
                    IngredientsListItem(ingredient: ingredient)
                    Divider()
                }
            }
            
            Group { // Steps
                HStack() {
                    Text("Steps to prepare:")
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                ForEach(recipe.steps) { step in
                    StepsListItem(step: step)
                    Divider()
                }
            }
            
            // The end
            Spacer()
                
            
        }
        .navigationBarTitle(recipe.title)
        .padding()
    }
    
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: recipeData[0])
    }
}
