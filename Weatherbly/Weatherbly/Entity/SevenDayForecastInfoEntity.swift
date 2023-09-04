//
//  TenDayForecastInfoEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/27.
//

import Foundation

// MARK: - TenDayForecastInfoEntity
struct SevenDayForecastInfoEntity: Decodable {
    let status: Int
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let list: List
}

// MARK: - List
struct List: Decodable {
    let temperature: [Temperature]
    let weather: [Weather]
}

struct Temperature: Decodable {
    let taMin: Int
    let taMinLow: Int
    let taMinHigh: Int
    let taMax: Int
    let taMaxLow: Int
    let taMaxHigh: Int
    let dayAfter: Int
    
    
}

// MARK: - Weather
struct Weather: Decodable {
    let rnStAm: Int?
    let rnStPm: Int?
    let wfAm: String?
    let wfPm: String?
    let rnSt: Int?
    let wf: String?
    let dayAfter: Int?
}
