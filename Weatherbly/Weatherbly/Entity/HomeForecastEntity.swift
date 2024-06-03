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
    let time: String
    let mainTemp: Int
    let minTemp: Int
    let maxTemp: Int
    let weather: String
    let comment: String
    
    enum CodingKeys: String, CodingKey {
        case date, time, mainTemp, minTemp, maxTemp, weather, comment
    }
}
