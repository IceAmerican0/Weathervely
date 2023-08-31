//
//  KeychainManager.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/28.
//

import KeychainAccess

class KeychainManager {
    static let shared = KeychainManager()
    
    #if DEBUG
    let keychain = Keychain(service: "com.redthree.weathervelytest")
    #else
    let keychain = Keychain(service: "com.redthree.weathervely")
    #endif
    
    let uuidKey = "UUIDKey"
    
    func saveUUID(_ uuid: String) {
        do {
            try keychain.set(uuid, key: uuidKey)
        } catch {
            print("Error saving UUID to Keychain: \(error)")
        }
    }
    
    func getUUID() -> String? {
        do {
            return try keychain.get(uuidKey)
        } catch {
            print("Error getting UUID from Keychain: \(error)")
            return nil
        }
    }
}
