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
        NavigationView {
            VStack {
                Divider()
                Text("Profile...")
                HStack {
                    Button(action: {
                        try! self.firebaseSession.logOut()
                    }) {
                        Text("Sign out")
                    }
                    Spacer()

                }.padding()
                Divider()
                Text(NSLocalizedString("Language", comment: "User prefs like language etc."))
                Button(action: {
                    print("Hallo Welt")
                }) {
                    Text("Change language")
                    // TODO: Open Settings when button is clicked
                }
                Spacer()
            }
        .navigationBarTitle(NSLocalizedString("Settings", comment: "Settings view nav bar title"))
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
