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
    @EnvironmentObject var networkManager: NetworkManager
    
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
                        Text(NSLocalizedString("Show completed", comment: "Show all elements"))
                    }
                }.background(
                    GeometryReader { g -> Text in
                        let frame = g.frame(in: CoordinateSpace.global)
                        if frame.origin.y > 250 && !self.networkManager.isLoadingList{
                            print("Loading....")
                            self.networkManager.isLoadingList = true
                            self.networkManager.reloadShoppingListData()
                            return Text("")
                        } else {
                            return Text("")
                        }
                    }
                )
                
                ForEach(networkManager.shoppingList) { item in
                    if (self.userData.showCompleted || !item.isCompleted) {
                        ShoppingListElement(item: item)
                    }
                }.onDelete { (offset) in
                    print(offset.count)
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Shopping List", comment: "Shopping List View Nav Bar Title")))
            .onAppear {
                self.networkManager.reloadShoppingListData()
            }
        }
    }
}

struct ShoppingList_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingList().environmentObject(UserData()).environmentObject(NetworkManager())
    }
}
