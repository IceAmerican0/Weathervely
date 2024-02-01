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
}

public struct TenDayForecastData: Codable {
//    let list: [TenDayForecastInfo]
    let currentTemp: Int
    let currentWeather: String
}

public struct TenDayForecastInfo {
    let date: String
    let minTemp: Int
    let maxTemp: Int
    let weatherAM: String
    let weatherPM: String
}
