//
//  MainView.swift
//  WSIE
//
//  Created by Pascal Boehler on 27.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct MainView: View {
    @ObservedObject var firebaseSession = FirebaseSession()
        
    var body: some View {
        Group {
            if (firebaseSession.isLoggedIn || firebaseSession.firebaseSession != nil || Auth.auth().currentUser != nil) {
                TabbarView().environmentObject(firebaseSession)
            } else {
                LoginView().environmentObject(firebaseSession)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
