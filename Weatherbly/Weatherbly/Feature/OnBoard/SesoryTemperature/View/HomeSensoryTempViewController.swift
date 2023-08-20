//
//  HomeSensoryTempViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/07.
//

import UIKit
import FlexLayout
import PinLayout
import Kingfisher



class HomeSensoryTempViewController: RxBaseViewController<HomeSensoryTempViewModel>, UIScrollViewDelegate{
    
//    weak var delegate: HomeSensoryTempViewControllerDelegate?
    // MARK: - Property
    
    var images = [UIImage(systemName: "star.fill"), UIImage(systemName: "book.fill"), UIImage(systemName:"scribble"),
                  UIImage(systemName:"lasso")]

    private var headerView = UIView()
    private var navigationDismissButton = UIButton()
    
    private var mainLabel = CSLabel(.bold, 22, "\(UserDefaultManager.shared.nickname)님에게\n적당한 옷차림을 골라주세요")
    private var discriptionLabel = CSLabel(.regular, 16 , "사진을 위로 밀면 옷이 더 두꺼워져요\n사진을 아래로 밀면 옷이 더 얇아져요")
    
    private var clothScrollViewWrapper = UIView()
    
    private var upperArrowButton = UIButton()
    private var downArrowButton = UIButton()
    private var tempWrapper = UIView()
    private var tempLabel =  CSLabel(.bold, 18, "선택 시간 (3℃)")
    private var scrollView = UIScrollView()
    private var imageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    private var bottomButton = CSButton(.primary)
    private let imageHeight = UIScreen.main.bounds.height * 0.38
    
    
    override init(_ viewModel: HomeSensoryTempViewModel) {
        super.init(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.delegate = self
    }
    
    func addContentscrollView() {
        guard let closetsList = viewModel.closetListByTempRelay.value else { return }
        
        for i in 0..<closetsList.count {
            let imageView = UIImageView()
            let yPos = scrollView.frame.height * CGFloat(i)
            imageView.frame = CGRect(x: 0, y: yPos, width: scrollView.bounds.width, height: scrollView.bounds.height)
            
            let imageUrl = closetsList[i].imageUrl
                if let url = URL(string: imageUrl) {
                    imageView.kf.indicatorType = .activity
                    imageView.kf.setImage(with: url,
                                          placeholder: nil,
                                          options: [.retryStrategy(DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(2))),
                                                    .transition(.fade(0.1)),
                                                    .cacheOriginalImage]) { result in
                     
                                                        switch result {
                                                        case .success:
                                                            break
                                                        case .failure:
                                                            break
                                                        }
                    }
                }
            
            scrollView.addSubview(imageView)
            scrollView.contentSize.height = imageView.frame.height * CGFloat(i + 1)
        }
    }
    
    
    
    // TODO: - Toast message 띄우기
    
    // MARK: - Attribute
    
    override func attribute() {
        super.attribute()
        
        navigationDismissButton.do {
            $0.setImage(AssetsImage.closeButton.image, for: .normal)
        }
        
        mainLabel.do {
            $0.setLineHeight(1.07)
        }
        
        clothScrollViewWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = CSColor._253_253_253.color
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1, 10)
            // TODO: - shadow처리
        }
        
        scrollView.do {
            $0.isPagingEnabled = true
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
        }
        
        upperArrowButton.do {
            $0.setImage(AssetsImage.upArrow.image, for: .normal)
        }
        
        tempLabel.do {
            $0.setBackgroundColor(CSColor._172_107_255_004.color)
            $0.addBorders([.top, .left, .right, .bottom])
            $0.setCornerRadius(5)
            $0.attributedText = NSMutableAttributedString()
                .bold($0.text ?? "", 16, CSColor._40_106_167)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        downArrowButton.do {
            $0.setImage(AssetsImage.downArrow.image, for: .normal)
        }
        
        discriptionLabel.do {
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 0
            $0.textColor = CSColor._102_102_102.color
            $0.setLineHeight(1.36)
            $0.attributedText = NSMutableAttributedString()
                .regular("사진을 " , 16, CSColor._102_102_102)
                .bold("위", 17, CSColor._102_102_102)
                .regular("로 밀면 옷이 더 " , 16, CSColor._102_102_102)
                .bold("두꺼워져요\n", 17, CSColor._102_102_102)
                .regular("사진을 " , 16, CSColor._102_102_102)
                .bold("아래", 17, CSColor._102_102_102)
                .regular("로 밀면 옷이 더 " , 16, CSColor._102_102_102)
                .bold("얇아져요", 17, CSColor._102_102_102)
        }
        
        bottomButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    // MARK: - Layout

    override func layout() {
        super.layout()
        
        container.flex
            .justifyContent(.spaceBetween)
            .paddingBottom(20)
            .define { flex in
            flex.addItem(headerView)
                .define { flex in
                    flex.addItem(navigationDismissButton)
                        .size(44)
                        .margin(15, 12, 0, 0)
            }
            
            flex.addItem(mainLabel)
                    .marginTop(-20)
            flex.addItem(clothScrollViewWrapper)
                .grow(1).shrink(1)
//                    .height(UIScreen.main.bounds.height * 0.52)
                .marginTop(20)
                .marginHorizontal(65)
                .paddingVertical(5)
                .justifyContent(.spaceAround)
                .define { flex in
                    flex.addItem(upperArrowButton).size(44).alignSelf(.center)
                    flex.addItem(tempLabel).marginTop(11)
                        .marginHorizontal(50)
                        .paddingVertical(3)
                    flex.addItem(scrollView)
                        .marginTop(13)
                        .width(50%)
                        .height(UIScreen.main.bounds.height * 0.37)
//                        .height(73%)
                        .alignSelf(.center)
                    flex.addItem(imageSourceLabel)
                        .marginTop(12)
                    flex.addItem(downArrowButton).size(44).marginTop(9).alignSelf(.center)
                }
            flex.addItem(discriptionLabel)
                .marginTop(15)
            flex.addItem(bottomButton)
                .marginTop(16)
                .marginHorizontal(43)
                .height(bottomButton.primaryHeight)
        }
        
        
    }
    
    // MARK: - Bind

    override func viewBinding() {
        super.viewBinding()
        
        navigationDismissButton.rx.tap
            .subscribe(onNext: { [ weak self ] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: bag)
        
        bottomButton.rx.tap
            .subscribe(onNext: { [weak self] tap in
                self?.viewModel.setSensoryTemperature()
//                self?.viewModel.dismissSelfWithAnimationRelay.accept(Void())
                
            }).disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.closetListByTempRelay
            .subscribe(onNext: { [ weak self ] closetList in
                guard let closetList = closetList else { return }
                self?.addContentscrollView()
                self?.scrollView.setContentOffset(CGPoint(x: 0, y: (self?.viewModel.focusingIndexRelay.value)!), animated: true)
                
            })
            .disposed(by: bag)
        
        viewModel.slotMachineIndexRelay
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.yOffsetForIndex(index, self?.scrollView)
            })
            .disposed(by: bag)

        viewModel.selectedTimeRelay
            .subscribe(onNext: {[weak self] text in
                guard var selectedTime = text,
                      let selectedTemp = self?.viewModel.selectedTempRelay.value
                else { return }
                
                if selectedTime == Date().todayThousandFormat { selectedTime = "현재"}
                self?.tempLabel.attributedText = NSMutableAttributedString()
                    .bold("\(selectedTime) (\(selectedTemp))", 16, CSColor._40_106_167)
            }).disposed(by: bag)
        
//        viewModel.emptyEntityRelay
//            .subscribe(onNext: { [weak self] result in
//                debugPrint("complete!!!")
//            }).disposed(by: bag)
        
        viewModel.getClosetBySensoryTemp()
    }
}

extension HomeSensoryTempViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.y / scrollView.frame.height)
        
        if let list = viewModel.closetListByTempRelay.value, pageIndex >= 0 && pageIndex < list.count {
            viewModel.setClosetIdRelay.accept(list[pageIndex].closetId)
            imageSourceLabel.text = "by \(list[pageIndex].shopName)"
        }
    }
}
