//
//  ShoppingListElement.swift
//  WSIE
//
//  Created by Pascal Boehler on 03.01.20.
//  Copyright © 2020 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct ShoppingListElement: View {
    @EnvironmentObject var userData: UserData
    var itemId: Int
    
    var body: some View {
        //Text("Hallo")
        HStack {
            Button(action: {
                self.userData.shoppingList[self.itemId].isCompleted = !self.userData.shoppingList[self.itemId].isCompleted
            }) {
                if (userData.shoppingList[itemId].isCompleted) {
                    Image(systemName: "checkmark.square.fill")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/)
                } else {
                    Image(systemName: "checkmark.square")
                }
            }
            Text(userData.shoppingList[itemId].itemAmount)
            Text(userData.shoppingList[itemId].itemTitle)
            Spacer()
        }
            .padding(10)
            .overlay(
               RoundedRectangle(cornerRadius: 25)
                   .stroke(Color.gray, lineWidth: 2)
            )
            .cornerRadius(25)
    }
}

fileprivate func completeItem(item: ShoppingListItem) -> ShoppingListItem {
    var item = item
    item.isCompleted = !item.isCompleted
    return item
}

struct ShoppingListElement_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListElement(itemId: 0)
    }
}
