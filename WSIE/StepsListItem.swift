//
//  StepsListItemWithoutImage.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct StepsListItem: View {
    var step: Step
    
    var body: some View {
        VStack {
            HStack {
                Text("Step \(step.id + 1):")
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            
            HStack {
                Text(step.description)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                Spacer()
            }
            
        }
    }
}

struct StepsListItem_Previews: PreviewProvider {
    static var previews: some View {
        StepsListItem(step: recipeData[0].steps[0])
    }
}
