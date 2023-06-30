//
//  UITextField+JJCAPI.swift
//  JJCTools
//
//  Created by mxgx on 2023/6/30.
//

import Foundation
import UIKit

extension UITextField {
    /// UITextField - 添加文本左侧间距
    public func jjc_leftMargin(_ margin: CGFloat) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: margin, height: 0.1))
        leftViewMode = .always
    }
}
