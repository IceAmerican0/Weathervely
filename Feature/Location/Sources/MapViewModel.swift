//
//  MapViewModel.swift
//  Weatherbly
//
//  Created by Khai on 8/30/24.
//

import WVAlert
import UIUtil
import WVNetwork
import UIKit
import CoreLocation
import RxCocoa

public protocol MapViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton()
    func getCoordToRegion(longitude: Double, latitude: Double)
    
    var isLoading: BehaviorRelay<Bool> { get }
    var popView: PublishRelay<Bool> { get }
    var pickedAddress: BehaviorRelay<String> { get }
}

public final class MapViewModel: RxBaseViewModel, MapViewModelLogic {
    private let regionDataSource: RegionDataSourceProtocol = RegionDataSource()
    private let userDataSource: UserDataSourceProtocol = UserDataSource()
    /// 로딩 상태
    public var isLoading = BehaviorRelay<Bool>(value: false)
    /// navigation pop 용도
    public var popView: PublishRelay<Bool> = .init()
    /// 지도 움직인 후 위치
    public var pickedAddress: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    /// 받아온 주소 정보
    private var addressInfo: AddressRequest = .init()
    
    public func didTapConfirmButton() {
        addAddress()
    }
    
    public func getCoordToRegion(longitude: Double, latitude: Double) {
        regionDataSource.coordToRegion(longitude: "\(longitude)", latitude: "\(latitude)")
            .subscribe(
                with: self,
                onNext: { owner, result in
                    owner.isLoading.accept(false)
                    
                    guard let info = result.documents.first else { return }
                    
                    if let address = info.address {
                        owner.addressInfo = AddressRequest(
                            address_name: address.addressName,
                            city: address.region1DepthName,
                            gu: address.region2DepthName,
                            dong: address.region3DepthName,
                            country: "kr",
                            x_code: latitude,
                            y_code: longitude
                        )
                    } else {
                        guard let address = info.roadAddress else { return }
                        owner.addressInfo = AddressRequest(
                            address_name: address.addressName,
                            city: address.region1DepthName,
                            gu: address.region2DepthName,
                            dong: address.region3DepthName,
                            country: "kr",
                            x_code: latitude,
                            y_code: longitude
                        )
                    }
                    
                    owner.pickedAddress.accept(owner.addressInfo.address_name ?? "")
                },
                onError: { owner, error in
                    owner.isLoading.accept(false)
                    debugPrint(error)
                }
            ).disposed(by: bag)
    }
    
    public func addAddress() {
        userDataSource.addAddress(addressInfo)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.getAddressList()
                },
                onError: { owner, error in
                    let errorString = error.localizedDescription
                    var closeAction: AlertActionHandler?
                    
                    if errorString == "중복된 주소를 등록 했습니다." {
                        closeAction = { owner.popView.accept(true) }
                    }
                    
                    AlertManager.shared.present(
                        state: .init(
                            title: errorString,
                            closeAction: closeAction
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    private func getAddressList() {
        userDataSource.getAddressList()
            .subscribe(
                with: self,
                onNext: { owner, result in
                    guard let id = result.data?.list.last?.id else { return }
                    owner.updateMainRegion(id: id)
                },
                onError : { owner, error in
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
                    )
                }
            ).disposed(by: bag)
    }
    
    private func updateMainRegion(id: Int) {
        userDataSource.setMainAddress(id)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    userDefault.set(owner.addressInfo.dong, forKey: UserDefaultKey.dong.rawValue)
                    owner.popView.accept(true)
                },
                onError: { owner, error in
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
                    )
            })
            .disposed(by: bag)
    }
}
