//
//  NetworkManager.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import Foundation

public final class NetworkManager {
    public static let shared = NetworkManager()
    
    public struct Config {
        public let baseURL: String
        public let uuid: String
        
        public init(baseURL: String, uuid: String) {
            self.baseURL = baseURL
            self.uuid = uuid
        }
    }
    
    private static var config: Config?
    
    public class func initialize(_ config: Config) {
        NetworkManager.config = config
    }
    
    public let baseURL: URL
    public let uuid: String
    
    public var domain: String {
        guard let host = baseURL.host else {
            fatalError("BaseURL host 파싱 실패")
        }
        return host
    }
    
    private init() {
        guard let config = NetworkManager.config else {
            fatalError("NetworkManager 초기화 실패")
        }
        
        guard let baseURL = URL(string: config.baseURL) else {
            fatalError("BaseURL 세팅 실패")
        }
        
        self.baseURL = baseURL
        self.uuid = config.uuid
    }
}
