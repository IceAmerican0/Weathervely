//
//  TenDayForecastEntity.swift
//  Weatherbly
//
//  Created by Khai on 1/30/24.
//

import Foundation

public struct TenDayForecastEntity: Codable {
    let status: Int
    let data: TenDayForecastData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct TenDayForecastData: Codable {
    let currentTemp: String
    let currentWeather: String
    let forecast: [TenDayForecastInfo]
    
    enum CodingKeys: String, CodingKey {
        case currentTemp, currentWeather, forecast
    }
}

public struct TenDayForecastInfo: Codable {
    public let date: String
    public let minTemp: Int
    public let maxTemp: Int
    public let weatherAM: String
    public let weatherPM: String
    public let rainAM: Int
    public let rainPM: Int
    
    enum CodingKeys: String, CodingKey {
        case date, minTemp, maxTemp, weatherAM, weatherPM, rainAM, rainPM
    }
}
