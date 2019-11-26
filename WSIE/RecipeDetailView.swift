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
        //Text("Hallo")
        VStack {
            Image(recipe.imageName)
                .resizable()
                .cornerRadius(25)
                .aspectRatio(3/2, contentMode: .fit)
                
            Divider()
            HStack {
                Text("For \(recipe.personAmount) person")
                    .font(Font.system(size: 12))
                Spacer()
                Image(systemName: "clock")
                Text(recipe.timeNeeded)
                    .font(Font.system(size: 12))
            }
            Divider()
            Text(recipe.shortDescription)
                .font(Font.system(size: 14))
                .multilineTextAlignment(.leading)
            Divider()
            HStack {
                Text("Materials needed:")
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                Button(action: {
                    print("Delete button tapped!")
                }) {
                    Image(systemName: "cart")
                    Text("Add to list")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
            }
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
