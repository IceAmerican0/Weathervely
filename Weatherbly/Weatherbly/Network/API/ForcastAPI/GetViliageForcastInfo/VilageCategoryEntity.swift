//
//  VilageCategoryEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/27.
//

import Foundation

struct VilageCategoryEntity: Decodable {
    let pcp: String
    let pop: String
    let pty: String
    let reh: String
    let sky: String
    let sno: String
    let tmn: String
    let tmp: String
    let tmx: String
    let uuu: String
    let vec: String
    let vvv: String
    let wav: String
    let wsd: String
    
    enum CodingKeys: String, CodingKey {
            case pcp = "PCP"
            case pop = "POP"
            case pty = "PTY"
            case reh = "REH"
            case sky = "SKY"
            case sno = "SNO"
            case tmn = "TMN"
            case tmp = "TMP"
            case tmx = "TMX"
            case uuu = "UUU"
            case vec = "VEC"
            case vvv = "VVV"
            case wav = "WAV"
            case wsd = "WSD"
    }
}
