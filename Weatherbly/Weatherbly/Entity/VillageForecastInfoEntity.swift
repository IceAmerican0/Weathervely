//
//  GetVillageForcastInfoEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/26.
//

/*
 기본적으로 한시간마다 받아옴
 기상청 -> api
 베이스 타임 / 데이트 -> 리퀘스트로 보낸거라 신경 x
 nx.ny -> ""

 1.카테고리 : 기상에 대한 카테고리
 2.fcst Date :  관측 일자
 3.Time : 관측 시간
 4.Value : 카테고리에 맞는 벨류 -> ex) SNO = 적설량이 얼마얼마 -> 문서에 보고 매핑해줘야함
 */

import Foundation

public struct VillageForecastInfoEntity: Codable {
    let status: Int
    let data: VillageForecastBody?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}

public struct VillageForecastBody: Codable {
    let list: [Int: DayForecast]
    
    public init(from decoder: Decoder) throws {
        var forecasts: [Int: DayForecast] = [:]
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var listContainer = try container.nestedUnkeyedContainer(forKey: .list)
        
        while !listContainer.isAtEnd {
            let forecast = try listContainer.decode(VillageFcstList.self)
            let date = Int(forecast.fcstDate)!
            forecasts[date, default: DayForecast(searchDate: date, forecasts: [])].forecasts.append(forecast)
        }
        self.list = forecasts
    }
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

public struct DayForecast : Codable {
    let searchDate: Int
    var forecasts: [VillageFcstList]
}
                     
public struct VillageFcstList: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let x: Int
    let y: Int
    
    enum CodingKeys: String, CodingKey {
        case baseDate = "baseDate"
        case baseTime = "baseTime"
        case category = "category"
        case fcstDate = "fcstDate"
        case fcstTime = "fcstTime"
        case fcstValue = "fcstValue"
        case x = "nx"
        case y = "ny"
    }
}


/*
 [
   {
     "baseDate": "20230725",
     "baseTime": "2300",
     "category": "TMP",
     "fcstDate": "20230726",
     "fcstTime": "0000",
     "fcstValue": "25",
     "nx": 60,
     "ny": 127
   },
   {
     "baseDate": "20230725",
     "baseTime": "2300",
     "category": "UUU",
     "fcstDate": "20230726",
     "fcstTime": "0000",
     "fcstValue": "-0.4",
     "nx": 60,
     "ny": 127
   },
 */
