//
//  UIImage+Extension.swift
//  Weatherbly
//
//  Created by Khai on 10/18/23.
//

import UIKit

extension UIImage {
    /// 이미지 크기 조절
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}

// MARK: Custom Image
extension UIImage {
    // Tab
    static let tab_home_nor = UIImage(named: "tab_home_nor")!
    static let tab_home_sel = UIImage(named: "tab_home_sel")!
    static let tab_mypage_nor = UIImage(named: "tab_mypage_nor")!
    static let tab_mypage_sel = UIImage(named: "tab_mypage_sel")!
    static let tab_style_nor = UIImage(named: "tab_style_nor")!
    static let tab_style_sel = UIImage(named: "tab_style_sel")!
    
    // Home Resources
    static let filter_exit = UIImage(named: "filter_exit")!
    static let filter_reset_dis = UIImage(named: "filter_reset_dis")!
    static let filter_reset = UIImage(named: "filter_reset")!
    static let filter_x = UIImage(named: "filter_x")!
    static let home_alarm = UIImage(named: "home_alarm")!
    static let home_banner_01 = UIImage(named: "home_banner_01")!
    static let home_date_left_dis = UIImage(named: "home_date_left_dis")!
    static let home_date_left_nor = UIImage(named: "home_date_left_nor")!
    static let home_date_right_dis = UIImage(named: "home_date_right_dis")!
    static let home_date_right_nor = UIImage(named: "home_date_right_nor")!
    static let home_drop_off = UIImage(named: "home_drop_off")!
    static let home_drop_on = UIImage(named: "home_drop_on")!
    static let home_nodata = UIImage(named: "home_nodata")!
    static let home_option = UIImage(named: "home_option")!
    static let home_place = UIImage(named: "home_place")!
    static let home_whether_empty = UIImage(named: "home_whether_empty")!

    // Home Weather
    static let clouds_am = UIImage(named: "clouds_am")!
    static let clouds_pm = UIImage(named: "clouds_pm")!
    static let cloudy = UIImage(named: "cloudy")!
    static let rainy = UIImage(named: "rainy")!
    static let snowy = UIImage(named: "snowy")!
    static let snowyRainy = UIImage(named: "snowyRainy")!
    static let sunny_am = UIImage(named: "sunny_am")!
    static let sunny_pm = UIImage(named: "sunny_pm")!
    static let windy = UIImage(named: "windy")!
    
    // Common
    static let networkError = UIImage(named: "networkError_illust")!
    static let loadError = UIImage(named: "popup_illust_loadError")!
    static let serverError = UIImage(named: "serverError_illust")!
    
    // Detail
    static let detail_empty = UIImage(named: "detail_empty")!
    static let moreCool_banner = UIImage(named: "moreCool_banner")!
    static let moreCool_illust = UIImage(named: "moreCool_illust")!
    static let moreHot_banner = UIImage(named: "moreHot_banner")!
    static let moreHot_illust = UIImage(named: "moreHot_illust")!
    
    // MyPage
    static let commontab = UIImage(named: "commontab")!
    static let icon_favorites = UIImage(named: "icon_favorites")!
    static let icon_plusL = UIImage(named: "icon_plusL")!
    static let icon_profile = UIImage(named: "icon_profile")!
    static let icon_set = UIImage(named: "icon_set")!
    static let icon_temperature = UIImage(named: "icon_temperature")!
    
    // Navigation
    static let navi_back = UIImage(named: "navigationBackButton")!
    static let navi_back_white = UIImage(named: "navi_back_white")!
    
    // Notification
    static let alarm_codi = UIImage(named: "alarm_codi")!
    static let alarm_empty = UIImage(named: "alarm_empty")!
    static let alarm_favorites = UIImage(named: "alarm_favorites")!
    static let alarm_set = UIImage(named: "alarm_set")!
    static let alarm_tip = UIImage(named: "alarm_tip")!
}
