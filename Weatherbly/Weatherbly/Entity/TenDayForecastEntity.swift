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
    let list: [TenDayForecastInfo]
    let currentTemp: Int
    let currentWeather: String
    
    enum CodingKeys: String, CodingKey {
        case list, currentTemp, currentWeather
    }
}

public struct TenDayForecastInfo: Codable {
    let date: String
    let minTemp: Int
    let maxTemp: Int
    let weatherAM: String
    let weatherPM: String
    let rainAM: Int
    let rainPM: Int
    
    enum CodingKeys: String, CodingKey {
        case date, minTemp, maxTemp, weatherAM, weatherPM, rainAM, rainPM
    }
}
