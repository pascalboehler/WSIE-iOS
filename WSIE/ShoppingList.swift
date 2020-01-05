//
//  ShoppingList.swift
//  WSIE
//
//  Created by Pascal Boehler on 03.01.20.
//  Copyright © 2020 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct ShoppingList: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $userData.showCompleted) {
                    HStack {
                        if (userData.showCompleted) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "checkmark")
                        }
                        Text(NSLocalizedString("Show completed", comment: "Also show completed elements when switch is toggled."))
                    }
                }
                ForEach(userData.shoppingList) { item in
                    if (self.userData.showCompleted || !item.isCompleted) {
                        ShoppingListElement(itemId: item.id)
                            
                    }
                    
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Shopping List", comment: "Shopping List View Nav Bar Title")))
        }
    }
}

struct ShoppingList_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingList()
    }
}
