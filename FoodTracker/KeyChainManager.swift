//
//  KeyChainManager.swift
//  FoodTracker
//
//  Created by Luiz on 6/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation

public enum KeychainManagerError: Error {
    case invalidContent
    case failure(status: OSStatus)
}

class KeychainManager {

    private func setupQueryDictionary(forKey key: String) -> [String: Any] {
        var queryDictionary: [String: Any] = [kSecClass as String: kSecClassGenericPassword]

        queryDictionary[kSecAttrAccount as String] = key.data(using: .utf8)
        return queryDictionary
    }

    public func set(string: String, forKey key: String) throws {
        guard !string.isEmpty && !key.isEmpty else {
            print("Can't add an empty string to the keychain")
            throw KeychainManagerError.invalidContent
        }
        do {
            try removeString(forKey: key)
        } catch {
            throw error
        }
        var queryDictionary = setupQueryDictionary(forKey: key)
        queryDictionary[kSecValueData as String] = string.data(using: .utf8)

        let status = SecItemAdd(queryDictionary as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainManagerError.failure(status: status)
        }
    }

    public func removeString(forKey key: String) throws {
        guard !key.isEmpty else {
            print("Key must be valid")
            throw KeychainManagerError.invalidContent
        }

        let queryDictionary = setupQueryDictionary(forKey: key)
        let status = SecItemDelete(queryDictionary as CFDictionary)
        if status != errSecSuccess {
            throw KeychainManagerError.failure(status: status)
        }
    }

    public func loadValue(forKey key: String) throws -> String? {
        guard !key.isEmpty else {
            throw KeychainManagerError.invalidContent
        }

        var queryDictionary = setupQueryDictionary(forKey: key)
        queryDictionary[kSecReturnData as String] = kCFBooleanTrue
        queryDictionary[kSecMatchLimit as String] = kSecMatchLimitOne

        var data: AnyObject?
        let status = SecItemCopyMatching(queryDictionary as CFDictionary, &data)
        guard status == errSecSuccess else {
            throw KeychainManagerError.failure(status: status)
        }

        let result: String?
        if let itemData = data as? Data {
            result = String(data: itemData, encoding: .utf8)
        } else {
            result = nil
        }
        return result
    }

}
