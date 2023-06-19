//
//  UIApplication+JJCAPI.swift
//  JJCTools
//
//  Created by mxgx on 2023/6/19.
//

import UIKit
import Foundation

// MARK: - 常见的跳转
extension UIApplication {
    /// UIApplication - 跳转 App 设置界面
    public func jjc_openAppSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
