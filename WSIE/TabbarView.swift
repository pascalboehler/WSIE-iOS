//
//  TabbarView.swift
//  WSIE
//
//  Created by Pascal Boehler on 23.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct TabbarView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var firebaseSession: FirebaseSession
    
    var body: some View {
        TabView {
            MyRecipeView()
                .tabItem {
                    if (userData.showFavouritesOnly) {
                        Image(systemName: "star.circle.fill")
                    } else {
                        Image(systemName: "book")
                    }
                    Text(NSLocalizedString("My Recipes", comment: "My Recipes View Tabbar title"))
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
            
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .environmentObject(firebaseSession)
        }
        
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
