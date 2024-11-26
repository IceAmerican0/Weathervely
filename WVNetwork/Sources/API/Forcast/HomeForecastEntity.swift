//
//  HomeForecastEntity.swift
//  Weatherbly
//
//  Created by Khai on 1/19/24.
//

import Foundation

public struct HomeForecastEntity: Codable {
    let status: Int
    public let data: HomeForecastData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct HomeForecastData: Codable {
    public let forecast: [HomeForecastInfo]
    
    enum CodingKeys: String, CodingKey {
        case forecast
    }
}

public struct HomeForecastInfo: Codable {
    public let date: String
    public let time: String?
    public let currentTemp: String
    public let minTemp: String
    public let maxTemp: String
    public let weather: String
    public let comment: String
    
    enum CodingKeys: String, CodingKey {
        case date, time, currentTemp, minTemp, maxTemp, weather, comment
    }
}
