//
//  Utility.swift
//  WSIE
//
//  Created by Pascal Boehler on 29.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import Foundation
import Alamofire

class Utility {
    static let applicationSupportedLanguages: [String] = ["de", "en"] // which language is my application supporting
}

class NetworkState {
    class func isConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


