//
//  MainView.swift
//  WSIE
//
//  Created by Pascal Boehler on 27.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        Group {
            if (userData.isLoggedIn) {
                TabbarView()
            } else {
                LoginView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
