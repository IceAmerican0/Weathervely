//
//  ClosetSectionModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/25/24.
//

import WVNetwork
import RxDataSources

public struct ClosetSectionModel {
    public var header: CategoryInfo
    public var items: [Item]
}

extension ClosetSectionModel: SectionModelType {
    
    public typealias Item = StyleClosetInfo

    public init(original: ClosetSectionModel, items: [StyleClosetInfo]) {
        self = original
        self.items = items
    }
}
