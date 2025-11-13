//
//  UISearchBar+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/7/28.
//

import Foundation
import UIKit

// MARK: - 设置系统属性
extension UISearchBar {
    /// UISearchBar - 去除搜索框黑线
    public func jjc_removeBlackLine() {
        searchBarStyle = .minimal
    }
    
    /// UISearchBar - 获取当前 TextField
    public func jjc_textField() -> UITextField? {
        if self.value(forKey: "searchField") is UITextField {
            let textField: UITextField = self.value(forKey: "searchField") as! UITextField
            return textField
        }
        return nil
    }
    
    /// UISearchBar - 设置当前 TextField 的背景色：bgColor
    public func jjc_textField(bgColor: UIColor) {
        if let textField: UITextField = jjc_textField() {
            textField.backgroundColor = bgColor
        }
    }
    
    /// UISearchBar - 设置当前 TextField 的圆角、边框、阴影：radius、width、color、shadowColor、shadowOffset、shadowOpacity、shadowRadius
    public func jjc_textField(radius: CGFloat,
                              border: (width: CGFloat?, color: UIColor?)?,
                              shadow: (color: UIColor?, offset: CGSize?, opacity: Float?, radius: CGFloat?)?) {
        if let textField: UITextField = jjc_textField() {
            textField.borderStyle = .none
            textField.layer.cornerRadius = radius
            textField.layer.masksToBounds = true
            if let borderWidth = border?.width {
                textField.layer.borderWidth = borderWidth
            }
            if let borderColor = border?.color {
                textField.layer.borderColor = borderColor.cgColor
            }
            if shadow != nil {
                textField.layer.masksToBounds = false
                if let shadowColor = shadow?.color {
                    textField.layer.shadowColor = shadowColor.cgColor
                }
                if let shadowOffset = shadow?.offset {
                    textField.layer.shadowOffset = shadowOffset
                }
                if let shadowOpacity = shadow?.opacity {
                    textField.layer.shadowOpacity = shadowOpacity
                }
                if let shadowRadius = shadow?.radius {
                    textField.layer.shadowRadius = shadowRadius
                }
            }
        }
    }
}
