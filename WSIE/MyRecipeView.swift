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
        NavigationView {
            List {
                Toggle(isOn: $userData.showFavouritesOnly) {
                    HStack {
                        Image(systemName: "star.circle")
                        Text(NSLocalizedString("Favourites only", comment: "Only show favourites when switch is toggled."))
                    }
                }
                
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
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("My Recipes", comment: "/")))
        }
    }
    
}

struct MyRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        MyRecipeView()
    }
}
