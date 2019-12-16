//
//  Settings.swift
//  WSIE
//
//  Created by Pascal Boehler on 29.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var firebaseSession: FirebaseSession
    
    var body: some View {
        VStack {
            Button(action: {
                try! self.firebaseSession.logOut()
            }) {
                Text("Sign out")
            }
            Button(action: {
                print("Hallo Welt")
            }) {
                Text("Change language")
            }   
        }
        .navigationBarTitle("Settings")
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
