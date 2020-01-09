//
//  ShoppingListElement.swift
//  WSIE
//
//  Created by Pascal Boehler on 03.01.20.
//  Copyright © 2020 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct ShoppingListElement: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State var item: ShoppingListItem
    
    var body: some View {
        //Text("Hallo")
        HStack {
            Button(action: {
                self.item.isCompleted = !self.item.isCompleted
                self.networkManager.updateShoppingListItem(itemId: self.item.id!, updatedItem: self.item)
            }) {
                if (item.isCompleted) {
                    Image(systemName: "checkmark.square")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/)
                } else {
                    Image(systemName: "square")
                }
            }
            Text("\(item.itemAmount) \(item.itemUnit)")
            Text(item.itemTitle)
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
        ShoppingListElement(item: shoppingListTestData[0])
    }
}
