//
//  User.swift
//  WSIE
//
//  Created by Pascal Boehler on 29.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import Foundation

class User {
    var uid: String
    var email: String?
    var displayName: String?
    
    init (uid: String, email: String?, displayName: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}
