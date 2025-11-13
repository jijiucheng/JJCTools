//
//  CALayer+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/7/28.
//

import Foundation
import UIKit

// MARK: - 扩展 CALayer 圆角、边框、阴影相关方法
extension CALayer {
    /// CALayer - 设置圆角、边框、阴影：radius、borderWidth、borderColor、shadowColor、shadowOffset、shadowOpacity、shadowRadius
    public func jjc_radiusBorderShadow(radius: CGFloat,
                                       border: (width: CGFloat?, color: UIColor?)?,
                                       shadow: (color: UIColor?, offset: CGSize?, opacity: Float?, radius: CGFloat?)?) {
        self.cornerRadius = radius
        self.masksToBounds = true
        if let borderWidth = border?.width {
            self.borderWidth = borderWidth
        }
        if let borderColor = border?.color {
            self.borderColor = borderColor.cgColor
        }
        if shadow != nil {
            self.masksToBounds = false
            if let shadowColor = shadow?.color {
                self.shadowColor = shadowColor.cgColor
            }
            if let shadowOffset = shadow?.offset {
                self.shadowOffset = shadowOffset
            }
            if let shadowOpacity = shadow?.opacity {
                self.shadowOpacity = shadowOpacity
            }
            if let shadowRadius = shadow?.radius {
                self.shadowRadius = shadowRadius
            }
        }
    }
    
    /// CALayer - 设置圆角、边框：radius、borderWidth、borderColor
    public func jjc_radiusBorder(radius: CGFloat, border: (width: CGFloat?, color: UIColor?)?) {
        jjc_radiusBorderShadow(radius: radius, border: border, shadow: nil)
    }
    
    /// CALayer - 设置圆角：radius
    public func jjc_radius(radius: CGFloat) {
        jjc_radiusBorderShadow(radius: radius, border: nil, shadow: nil)
    }
}
