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
    @State var isLoading: Bool = false
    
    var body: some View {
        
        NavigationView {
            List {
                Toggle(isOn: $userData.showFavouritesOnly) {
                    HStack {
                        Image(systemName: "star.circle")
                        Text(NSLocalizedString("Favourites only", comment: "Only show favourites when switch is toggled."))
                    }
                }.background(
                    GeometryReader { g -> Text in
                        let frame = g.frame(in: CoordinateSpace.global)
                        if frame.origin.y > 250 && !self.networkManager.isLoading{
                            self.networkManager.isLoading = true
                            self.networkManager.reloadData()
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
