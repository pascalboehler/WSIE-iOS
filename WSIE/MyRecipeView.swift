//
//  MyRecipeView.swift
//  WSIE
//
//  Created by Pascal Boehler on 22.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct MyRecipeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hallo")
                Text("Test")
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
