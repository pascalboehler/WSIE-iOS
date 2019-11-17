//
//  Hasher.swift
//  Hasher
//
//  Created by Andrea Altea on 09/03/2019.
//

import Foundation
import CommonCrypto

public struct Hasher {
    
    public let data: Data?
    
    public init(_ data: Data?) {
        self.data = data
    }
}

public extension Hasher {
    
    /// Hashing algorithm that prepends an RSA2048ASN1Header to the beginning of the data being hashed.
    ///
    /// - Parameters:
    ///   - type: The type of hash algorithm to use for the hashing operation.
    ///   - output: The type of output string desired.
    /// - Returns: A hash string using the specified hashing algorithm, or nil.
    func hashWithRSA2048Asn1Header(_ type: HashType, output: OutputType = .hex) -> String? {
        
        guard let data = self.data else { return nil }
        
        let rsa2048Asn1Header:[UInt8] = [
            0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
            0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
        ]
        
        var headerData = Data(bytes: rsa2048Asn1Header)
        headerData.append(data)
        return hashed(type, output: output)
    }
    
    /// Hashing algorithm for hashing a Data instance.
    ///
    /// - Parameters:
    ///   - type: The type of hash to use.
    ///   - output: The type of hash output desired, defaults to .hex.
    ///   - Returns: The requested hash output or nil if failure.
    func hashed(_ type: HashType, output: OutputType) -> String? {
        
        guard let data = self.data else { return nil }
        
        var digest = Data(count: Int(type.length))
        _ = digest.withUnsafeMutableBytes { (digestBytes: UnsafeMutablePointer<UInt8>) in
            data.withUnsafeBytes { (messageBytes: UnsafePointer<UInt8>) in
                let length = CC_LONG(data.count)
                switch type {
                case .md5: CC_MD5(messageBytes, length, digestBytes)
                case .sha1: CC_SHA1(messageBytes, length, digestBytes)
                case .sha224: CC_SHA224(messageBytes, length, digestBytes)
                case .sha256: CC_SHA256(messageBytes, length, digestBytes)
                case .sha384: CC_SHA384(messageBytes, length, digestBytes)
                case .sha512: CC_SHA512(messageBytes, length, digestBytes)
                }
            }
        }
        return output.parse(from: digest)
    }
}

public extension Hasher {
    
    func md5(_ output: OutputType = .hex) -> String? {
        return self.hashed(.md5, output: output)
    }
    
    func sha1(_ output: OutputType = .hex) -> String? {
        return self.hashed(.sha1, output: output)
    }

    func sha224(_ output: OutputType = .hex) -> String? {
        return self.hashed(.sha224, output: output)
    }

    func sha256(_ output: OutputType = .hex) -> String? {
        return self.hashed(.sha256, output: output)
    }

    func sha384(_ output: OutputType = .hex) -> String? {
        return self.hashed(.sha384, output: output)
    }

    func sha512(_ output: OutputType = .hex) -> String? {
        return self.hashed(.sha512, output: output)
    }
}
