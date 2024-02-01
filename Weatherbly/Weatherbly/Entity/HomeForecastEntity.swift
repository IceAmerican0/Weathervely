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
}

public struct HomeForecastData: Codable {
//    let list: [HomeForecastInfo]
}

public struct HomeForecastInfo {
    let date: String
    let time: String
    let mainTemp: Int
    let minTemp: Int
    let maxTemp: Int
    let weather: String
    let comment: String
}
