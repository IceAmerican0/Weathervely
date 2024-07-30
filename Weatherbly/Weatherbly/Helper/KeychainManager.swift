//
//  KeychainManager.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/28.
//

import KeychainAccess

public final class KeychainManager {
    static let shared = KeychainManager()
    
    var keychain: Keychain
    
    private init() {
        switch AppEnvironment.shared.environmentType {
        case .production: 
            keychain = Keychain(service: Constants.KeychainKey.production)
        case .develop:
            keychain = Keychain(service: Constants.KeychainKey.develop)
        }
    }
    
    let uuidKey = "UUIDKey"
    
    func saveUUID(_ uuid: String) {
        do {
            try keychain.set(uuid, key: uuidKey)
        } catch {
            debugPrint("Error saving UUID to Keychain: \(error)")
        }
    }
    
    func getUUID() -> String? {
        do {
            return try keychain.get(uuidKey)
        } catch {
            debugPrint("Error getting UUID from Keychain: \(error)")
            return nil
        }
    }
    
    func deleteUUID() {
        do {
            userDefault.removeObject(forKey: UserDefaultKey.uuid.rawValue)
            try keychain.remove(keychain.service)
        } catch {
            debugPrint("Error deleting UUID from Keychain: \(error)")
        }
    }
}
