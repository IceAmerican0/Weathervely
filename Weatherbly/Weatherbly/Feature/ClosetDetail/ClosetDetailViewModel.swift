//
//  ClosetDetailViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ClosetDetailViewModel: RxBaseViewModel {
    
    private let closetDetailDataSource = ClosetDetailDataSource()
    
    /// 선택된 옷 정보
    public var selectedClosetInfo = PublishRelay<SelectedClosetInfo>()
    /// 함께착용한 아이템 정보
    public var withItemInfo = PublishRelay<WithItemsInfo>()
    /// Warmmer closets
    public var warmFirstRowInfo = PublishRelay<FirstRow>()
    public var warmSecondRowInfo = PublishRelay<SecondRow>()
    /// Cooler losets
    public var coolFirstRowInfo = PublishRelay<FirstRow>()
    public var coolSecondRowInfo = PublishRelay<SecondRow>()
    
    
    func getClosetDetail(closetId: Int) {
        closetDetailDataSource.getClosetDetail(closetId: closetId)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let data = response.data else { return }
                    if let detailInfo = data.selectedCloset,
                       let withItemInfo = data.withItems {
                        owner.selectedClosetInfo.accept(detailInfo)
                        owner.withItemInfo.accept(withItemInfo)
                    }
                })
            .disposed(by: bag)
    }
    
    func getWarmmerClosets(closetId: Int, page: Int) {
        closetDetailDataSource.getWarmmerCloset(closetId: closetId, page: page)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let dataList = response.data?.list else { return }
                    if let firstRow  = dataList.firstRow,
                       let secondRow = dataList.secondRow {
                        
                    }
                    
                }).disposed(by: bag)
    }
    
    
    func getCoolerClosets(closetId: Int, page: Int) {
        closetDetailDataSource.getCoolerCloset(closetId: closetId, page: page)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let dataList = response.data?.list else { return }
                    if let firstRow  = dataList.firstRow,
                       let secondRow = dataList.secondRow {
                        
                    }
                    
                }).disposed(by: bag)
    }
}
