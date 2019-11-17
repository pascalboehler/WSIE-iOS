//
//  Hasher+Data.swift
//  Hasher
//
//  Created by Andrea Altea on 08/03/2019.
//

import Foundation

public protocol HasherCompatible {
    
    associatedtype CompatibleType
    
    var hasher: Hasher { get }
    
    var hasher_data: Data? { get }
}

extension HasherCompatible {
    
    public var hasher: Hasher {
        return Hasher(self.hasher_data)
    }
}

extension String: HasherCompatible {
    public typealias CompatibleType = String
    
    public var hasher_data: Data? {
        return self.data(using: .utf8)
    }
}

extension Data: HasherCompatible {
    public typealias CompatibleType = Data
    
    public var hasher_data: Data? {
        return self
    }
}
