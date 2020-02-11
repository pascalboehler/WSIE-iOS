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
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Toggle(isOn:  $userData.showFavouritesOnly) {
                        HStack {
                            Image(systemName: "star.circle")
                            Text(NSLocalizedString("Favourites only", comment: "Only show favourites when switch is toggled."))
                        }
                    }.background(
                        GeometryReader { g -> Text in
                            let frame = g.frame(in: CoordinateSpace.global)
                            if frame.origin.y > 250 && !self.networkManager.isLoadingRecipes{
                                self.networkManager.isLoadingRecipes = true
                                self.networkManager.reloadRecipeData()
                                return Text("")
                            } else {
                                return Text("")
                            }
                        }
                    )
                    
                    
                    
                    ForEach(networkManager.recipes) { recipe in
                        if (!self.userData.showFavouritesOnly || recipe.isFavourite) && recipe.language == Bundle.preferredLocalizations(from: Utility.applicationSupportedLanguages).first{
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                HStack {
                                    Spacer()
                                    RecipeListItem(recipe: recipe)
                                        .aspectRatio(300/200, contentMode: .fit)
                                        .overlay(
                                           RoundedRectangle(cornerRadius: 25)
                                               .stroke(Color.gray, lineWidth: 2)
                                        )
                                        .cornerRadius(25)
                                    Spacer()
                                }
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }.onDelete { (offset) in
                        guard let index = offset.first else {
                            print("Unable to delete element!")
                            return
                        }
                        self.networkManager.deleteRecipe(recipeId: index)
                    }
                }
                .navigationBarTitle(Text(NSLocalizedString("My Recipes", comment: "/")))
                .navigationBarItems(trailing:
                    NavigationLink(destination: CreateRecipeView(), label: {
                        Image(systemName: "square.and.pencil")
                    })
                )
            }
            
            if (self.networkManager.isLoadingRecipes) {
                ActivityIndicator(style: .large)
            }
        }
    }
    
}

struct MyRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        MyRecipeView()
    }
}
