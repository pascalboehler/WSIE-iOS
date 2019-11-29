//
//  FirebaseUtility.swift
//  WSIE
//
//  Created by Pascal Boehler on 29.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

class FirebaseSession: ObservableObject {
    
    // MARK: Properties
    @Published var firebaseSession: User?
    @Published var isLoggedIn: Bool = false
    @EnvironmentObject var userData: UserData
    
    // MARK: Functions
    func listen() {
        _ = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.firebaseSession = User(uid: user.uid, email: user.email, displayName: user.displayName)
                self.isLoggedIn = true
                print("logged in")
            } else {
                self.isLoggedIn = false
                self.firebaseSession = nil
            }
        })
    }
    
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, err) in
            if let err = err {
                print("Something went wrong \(err.localizedDescription)")
            } else {
                if let authResult = authResult {
                    let user = authResult.user
                    self.firebaseSession = User(uid: user.uid, email: user.email, displayName: user.displayName)
                    self.isLoggedIn = true
                    print("isloggedin")
                } else {
                    print("Something went wrong \(err?.localizedDescription ?? "ERROR: unable to load error")")
                }
            }
        }
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
        self.isLoggedIn = false
        self.firebaseSession = nil
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, err) in
            if let err = err {
                print("Something went wrong \(err.localizedDescription)")
            } else {
                if let authResult = authResult {
                    let user = authResult.user
                    self.firebaseSession = User(uid: user.uid, email: user.email, displayName: user.displayName)
                    self.isLoggedIn = true
                } else {
                    print("Something went wrong \(err?.localizedDescription ?? "ERROR: unable to load error")")
                }
            }
        }
    }
    
    
}
