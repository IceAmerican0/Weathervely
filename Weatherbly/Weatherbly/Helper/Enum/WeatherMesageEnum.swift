//
//  WeatherMessageEnum.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/18.
//

import Foundation

enum WeatherMsgEnum {
    
    case seonsoryDiffMsg(_ userTempDiff: Int)
    case sunnyNormalMsg
    case sunnyGoodMsg
    case currentRainMsg
    case futureRainMsg(_ POP: Int)
    case currrentRainSnowMsg
    case futureRainSnowMsg(_ POP: Int)
    case currentSnowMsg
    case futureSnowMsg(_ POP: Int)
    case currenstShowerMsg
    case futureShowerMsg
    case strongWindMsg
    case normalWindMsg
    case lowHumidity
    case highHumidity
    case cloudyMsg01
    case cloudyMsg02
    
    var msg: String {
        switch self {
        case .seonsoryDiffMsg(let userTempDiff):
            if userTempDiff > 0 {
                return "🌡️ 표준보다 \(userTempDiff)도 더 높은 온도로 설정됐어요"
            } else {
                return "🌡️ 표준보다 \(userTempDiff)도 더 낮은 온도로 설정됐어요"
            }
            
        case .sunnyNormalMsg:
            return "날씨도 맑게, 내 기분도 맑게. 파이팅! 😆"
        case .sunnyGoodMsg:
            return "산책하기 좋은 날씨예요 ☘️"
        case .currentRainMsg:
            return "☔ 비가 와요. 우산 챙기셨나요?"
        case .futureRainMsg(let POP):
            return "🌂비 올 확률이 \(POP)%에요"
        case .currrentRainSnowMsg:
            return "☔ 눈비가 내려요. 바닥이 미끄러울 수 있어요"
        case .futureRainSnowMsg(let POP):
            return "🌂눈과 비가 함께 올 확률이 \(POP)%에요"
        case .currentSnowMsg:
            return "❄️ 눈이 내려요. 바닥이 미끄러울 수 있어요"
        case .futureSnowMsg(let POP):
            return "❄️눈 올 확률이 \(POP)%에요"
        case .currenstShowerMsg:
            return "☔ 소나기가 내려요"
        case .futureShowerMsg:
            return "🌂곳곳에 소나기가 내릴 수 있어요"
        case .strongWindMsg:
            return "🌬️ 바람이 세차게 불어요"
        case .normalWindMsg:
            return "바람에 골치 아픈 생각 다 날려버려요 😎"
        case .lowHumidity:
            return "건조한 날씨에요. 물을 자주 마셔주세요"
        case .highHumidity:
            return "습해서 불쾌할 수 있는 날씨예요"
        case .cloudyMsg01:
            return "구름이 자욱하고 흐린 날씨에요"
        case .cloudyMsg02:
            return "흐린 날, 오히려 좋아요 🥹"
        }
    }
}
