//
//  LoginView.swift
//  WSIE
//
//  Created by Pascal Boehler on 27.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var firebaseSession: FirebaseSession
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        
        VStack(spacing: 20) {
                Text("Sign In")
                TextField("Email", text: $email)
                
                SecureField("Password", text: $password)
                Button(action: {
                    self.firebaseSession.logIn(email: self.email, password: self.password)
                    self.email = ""
                    self.password = ""
                }) {
                    Text("Sign In")
                }
                .padding()
                Button(action: {
                    self.firebaseSession.signUp(email: self.email, password: self.password)
                    self.email = ""
                    self.password = ""
                }) {
                    Text("Sign Up")
                }
                .padding()
            }
        .padding()

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
