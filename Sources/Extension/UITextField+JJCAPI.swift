//
//  UITextField+JJCAPI.swift
//  JJCTools
//
//  Created by mxgx on 2023/6/30.
//

import Foundation
import UIKit

extension UITextField {
    /// UITextField - 添加文本两侧间距
    public func jjc_margin(_ left: CGFloat? = nil, _ right: CGFloat? = nil) {
        guard left != nil && right != nil else { return }
        if let leftMargin = left {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftMargin, height: 0.1))
            leftViewMode = .always
        }
        if let rightMargin = right {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightMargin, height: 0.1))
            rightViewMode = .always
        }
    }
}
