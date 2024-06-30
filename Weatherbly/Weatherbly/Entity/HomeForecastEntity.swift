//
//  HomeForecastEntity.swift
//  Weatherbly
//
//  Created by Khai on 1/19/24.
//

import Foundation

public struct HomeForecastEntity: Codable {
    let status: Int
    let data: HomeForecastData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct HomeForecastData: Codable {
    let forecast: [HomeForecastInfo]
    
    enum CodingKeys: String, CodingKey {
        case forecast
    }
}

public struct HomeForecastInfo: Codable {
    let date: String
    let time: String?
    let currentTemp: String
    let minTemp: String
    let maxTemp: String
//    let weather: String
    let comment: String
    
    enum CodingKeys: String, CodingKey {
        case date, time, currentTemp, minTemp, maxTemp, /*weather,*/ comment
    }
}
