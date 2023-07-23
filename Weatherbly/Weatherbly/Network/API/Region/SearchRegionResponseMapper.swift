//
//  SearchRegionResponseMapper.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/17.
//

public extension SearchRegionEntity {
    func toRegionInfo() -> RegionInfo {
        return .init(documents: documents.map { $0.toDocumentList() })
    }
}

public extension SearchRegionEntity.DocumentList {
    func toDocumentList() -> Documents {
        return .init(
            longitude: self.x ?? "",
            latitude: self.y ?? "",
            address: self.address.map { $0.toAddressList() }
        )
    }
}

public extension SearchRegionEntity.AddressList {
    func toAddressList() -> Address {
        return .init(
            region1: self.region_1depth_name ?? "",
            region2: self.region_2depth_name ?? "",
            region3: self.region_3depth_name ?? ""
        )
    }
}
