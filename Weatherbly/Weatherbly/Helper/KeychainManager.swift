//
//  KeychainManager.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/28.
//

import KeychainAccess

class KeychainManager {
    static let shared = KeychainManager()
    
    let keychain = Keychain(service: "com.redthree.weathervely") // 고유한 서비스 ID를 사용합니다.
    let uuidKey = "UUIDKey" // UUID 값을 저장할 키 이름입니다.
    
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
