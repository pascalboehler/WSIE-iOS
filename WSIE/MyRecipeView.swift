//
//  MyRecipeView.swift
//  WSIE
//
//  Created by Pascal Boehler on 22.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct MyRecipeView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $userData.showFavouritesOnly) {
                    HStack {
                        Image(systemName: "star.circle")
                        Text("Favourites only")
                    }
                }
                
                ForEach(userData.recipes) { recipe in
                    if !self.userData.showFavouritesOnly || recipe.isFavourite {
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            HStack {
                               Spacer()
                               RecipeListItemView(recipe: recipe)
                               .frame(height: 270, alignment: .center)
                               .overlay(
                                   RoundedRectangle(cornerRadius: 25)
                                       .stroke(Color.gray, lineWidth: 2)
                               )
                               .cornerRadius(25)
                               Spacer()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("My Recipes"))
        }
    }
}

struct MyRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        MyRecipeView()
    }
}
