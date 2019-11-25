//
//  RecipeListItemView.swift
//  WSIE
//
//  Created by Pascal Boehler on 23.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct RecipeListItemView: View {
    var body: some View {
        VStack {
            Image("NoPhoto")
                .resizable()
                .frame(height: 200)
                .clipped()

            Spacer()
            Text("Recipe title")
            HStack {
                Spacer()
                Text("For x person")
                Spacer()
                Image(systemName: "clock.fill")
                Text("12 min")
                    .multilineTextAlignment(.leading)
                    .padding(.trailing)
                Spacer()
            }
            Spacer()
        }
    }
}

struct RecipeListItemView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListItemView()
            .previewLayout(.fixed(width: 300, height: 270))
    }
}

