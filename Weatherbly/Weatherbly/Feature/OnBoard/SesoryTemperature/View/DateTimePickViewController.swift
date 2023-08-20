//
//  DateTimePickViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/14.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift
import Toast

final class DateTimePickViewController: RxBaseViewController<DateTimePickViewModel> {
    // MARK: - UI Property
    private let headerWrapper = UIView()
    private var progressBar = CSProgressView(0.75)
    private let navigationBackButton = UIButton()
    
    private let titleMessageLabel = CSLabel(.bold, 22, "나에게 딱 맞는\n체감온도를 설정해보세요")
    private let clockImage = UIImageView(image: AssetsImage.clockIcon.image)
    
    private let questionLabel = CSLabel(.bold, 20, "언제 외출하셨나요?")
    
    private var datePickerWrapper = UIView()
    private var gradientLayer = CAGradientLayer()
    private var dateTimePickerView = UIPickerView()
    
    private let discriptionLabel = CSLabel(.regular, 18, "외출하신 시간을 기준으로\n체감온도를 조절할 수 있어요")
    
    private let bottomButton = CSButton(.primary)
    
    var pickerFirstRowData = ["어제","오늘"]
    var pickerSecondRowData = ["오전","오후"]
    var pickerThirdRowData = [1,2,3,4,5,6,7,8,9,10,11,12]
    
    // MARK: - Life Cycle Propery
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTimePickerView.delegate = self
        dateTimePickerView.dataSource = self
        dateTimePickerView.selectRow(6, inComponent: 2, animated: true)
    }
    
    // MARK: - layout
    override func attribute() {
        super.attribute()

        navigationBackButton.do {
            $0.setImage(AssetsImage.navigationBackButton.image, for: .normal)
        }
        
        bottomButton.do {
            $0.setTitle("확인", for: .normal)
        }
        
        gradientLayer.do {
            $0.setGradient(color:[CSColor._237_237_237.cgColor,CSColor._255_255_255_05.cgColor,CSColor._255_255_255_05.cgColor,CSColor._255_255_255_05.cgColor,CSColor._210_210_210.cgColor],
                           locations: [0.0, 0.2, 0.4, 0,6, 0.8, 1.0], 20)
            $0.setShadow(CGSize(width: 0, height: 4),CSColor._220_220_220.cgColor , 1, 2)
        }
        
        datePickerWrapper.do {
            $0.addGradientLayer(gradientLayer)
        }
        
        discriptionLabel.do {
            $0.setLineHeight(1.3)
        }
//        dateTimePickerView.selectRow(6, inComponent: 2, animated: true)
    }
    
    override func layout() {
        super.layout()
        
        container.flex
            .define { flex in
                flex.addItem(headerWrapper).define { flex in
                    flex.addItem(progressBar)
                    flex.addItem(navigationBackButton).left(12).size(44).marginTop(15)
                }
                
                flex.addItem(titleMessageLabel)
                    .marginTop(4)
                    .marginHorizontal(65)
                
                flex.addItem(clockImage)
                    .size(44)
                    .alignSelf(.center)
                    .marginVertical(20)
                flex.addItem(questionLabel)
                    .marginHorizontal(118)
                    
                flex.addItem(datePickerWrapper)
                    .height(UIScreen.main.bounds.height * 0.22)
                    .marginTop(33)
                    .marginHorizontal(43)
                    .define { flex in
                        flex.addItem(dateTimePickerView)
                    }
                flex.addItem(discriptionLabel)
                    .marginTop(33)
                flex.addItem(bottomButton)
                    .marginTop(UIScreen.main.bounds.height * 0.11)
                    .height(bottomButton.primaryHeight)
                    .marginHorizontal(43)
                    
                bottomButton.pin.bottom(53)
//                    .bottom(view.pin.safeArea.bottom + 53)
//                    .marginBottom(53)
            }
    }
    
    // MARK: - binding
    override func bind() {
        super.bind()
        
        bottomButton.rx.tap
            .subscribe (onNext: { [weak self] _ in
                let date = Date()
                let today = date.todayDatePickerFormat.components(separatedBy: " ").map{ $0 }
//                debugPrint("현재시간: ", today)
                
                // Get Picker value
                let pickerDay: String = self?.pickerFirstRowData[(self?.dateTimePickerView.selectedRow(inComponent: 0))  ?? 0] ?? "어제"
                
                let pickerDayTime: String = self?.pickerSecondRowData[(self?.dateTimePickerView.selectedRow(inComponent: 1)) ?? 0] ?? "오전"
                
                let pickerTime: Int = Int(self?.pickerThirdRowData[(self?.dateTimePickerView.selectedRow(inComponent: 2)) ?? 6] ?? 7)
                self?.viewModel.didTapConfirmButton(today, pickerDay, pickerDayTime, pickerTime)
            })
            .disposed(by: bag)
    }
}

extension DateTimePickViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 // 어제,오늘/ 오전,오후/ 시
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return pickerFirstRowData.count
        case 1:
            return pickerSecondRowData.count
        case 2:
           if pickerView.selectedRow(inComponent: 0) == 0 && pickerView.selectedRow(inComponent: 1) == 0 {
               return pickerThirdRowData.count - 3 // to hide 1, 2, 3
           } else {
               return pickerThirdRowData.count
           }
       default:
           return 0
       }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return pickerFirstRowData[row]
        case 1:
            return pickerSecondRowData[row]
        case 2:
                if pickerView.selectedRow(inComponent: 0) == 0 && pickerView.selectedRow(inComponent: 1) == 0 {
                    return "\(pickerThirdRowData[row + 3])" // Offset by 3 to hide the first three numbers
                } else {
                    return "\(pickerThirdRowData[row])"
                }
        default:
            return nil
        
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 || component == 1 {
            pickerView.reloadComponent(2)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let attributes = [
               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
               NSAttributedString.Key.foregroundColor: UIColor.black
           ]
        
        switch component {
           case 0:
               return NSAttributedString(string: pickerFirstRowData[row], attributes: attributes)
           case 1:
               return NSAttributedString(string: pickerSecondRowData[row], attributes: attributes)
           case 2:
               if pickerView.selectedRow(inComponent: 0) == 0 && pickerView.selectedRow(inComponent: 1) == 0 {
                   return NSAttributedString(string: "\(String(pickerThirdRowData[row + 3])) 시", attributes: attributes)
               } else {
                   return NSAttributedString(string: "\(String(pickerThirdRowData[row])) 시", attributes: attributes)
               }
           default:
               return nil
           }
        
   }
}
