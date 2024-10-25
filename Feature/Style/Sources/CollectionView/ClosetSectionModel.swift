//
//  ClosetSectionModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/25/24.
//

import Network
import RxDataSources

struct ClosetSectionModel {
    var header: CategoryInfo
    var items: [Item]
}

extension ClosetSectionModel: SectionModelType {
    
    public typealias Item = StyleClosetInfo

    init(original: ClosetSectionModel, items: [StyleClosetInfo]) {
        self = original
        self.items = items
    }
}
