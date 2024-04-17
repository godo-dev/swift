//
//  get-keychain-value.swift
//  get-keychain-value
//
//  Created by Junian Triajianto on 2024-04-17.
//

import Foundation
import Security

func getKeychainPassword(service: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: kCFBooleanTrue as Any,
        kSecReturnData as String: kCFBooleanTrue as Any
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    guard status == errSecSuccess else {
        debugPrint("Error retrieving password: \(status)")
        return nil
    }
    
    guard let existingItem = item as? [String: Any],
          let passwordData = existingItem[kSecValueData as String] as? Data,
          let password = String(data: passwordData, encoding: .utf8) else {
        debugPrint("Failed to decode password")
        return nil
    }
    
    return password
}

let keychainKey = "Chrome Safe Storage"

print("Getting '\(keychainKey)' from Keychain.")
print("You'll be asked for machine password by macOS.")

if let keychainValue = getKeychainPassword(service: keychainKey)
{
    print("\(keychainKey): \(keychainValue)")
}
else
{
    print("'\(keychainKey)' not found in Keychain")
}
