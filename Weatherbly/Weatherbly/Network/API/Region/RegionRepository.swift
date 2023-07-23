////
////  RegionRepository.swift
////  Weatherbly
////
////  Created by 박성준 on 2023/07/17.
////
//
//import RxSwift
//
//public protocol RegionRepositoryProtocol {
//    func searchRegion(query: String) -> Observable<RegionInfo>
//}
//
//public struct RegionRepository: RegionRepositoryProtocol {
//    private let dataSource: RegionDataSourceProtocol
//
//    public init(dataSource: RegionDataSourceProtocol) {
//        self.dataSource = dataSource
//    }
//
//    public func searchRegion(query: String) -> Observable<RegionInfo> {
////        let mapper = RegionQueryMapper(query: query)
////
////        return dataSource
////            .searchRegion(mapper.toSearchRegionRequest())
////            .map { $0.toRegionInfo() }
////            .asObservable()
//        return
//    }
//}
