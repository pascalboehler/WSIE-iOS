//
//  OutputType.swift
//  Hasher
//
//  Created by Andrea Altea on 08/03/2019.
//

import Foundation

// Defines types of hash string outputs available
public enum OutputType {
    // standard hex string output
    case hex
    // base 64 encoded string output
    case base64
}

extension OutputType {
    
    func parse(from digest: Data) -> String {
        
        switch self {
            case .hex: return digest.map { String(format: "%02hhx", $0) }.joined()
            case .base64: return digest.base64EncodedString()
        }
    }
}
