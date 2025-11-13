//
//  UIView+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/7/28.
//

import Foundation
import UIKit

// MARK: - 扩展 UIView 位置尺寸
extension UIView {
    /// UIView - 距离顶部间距 y
    public var jjc_top: CGFloat {
        set { frame.origin.y = newValue }
        get { return frame.origin.y }
    }
    
    /// UIView - 距离左侧间距 x
    public var jjc_left: CGFloat {
        set { frame.origin.x = newValue }
        get { return frame.origin.x }
    }
    
    /// UIView - 距离底部间距 y + height
    public var jjc_bottom: CGFloat {
        set { frame.origin.y = newValue - frame.size.height }
        get { return (frame.origin.y + frame.size.height) }
    }
    
    /// UIView - 距离右侧间距 x + width
    public var jjc_right: CGFloat {
        set { frame.origin.x = newValue - frame.size.width }
        get { return (frame.origin.x + frame.size.width) }
    }
    
    /// UIView - 中心点 x
    public var jjc_centerX: CGFloat {
        set { center.x = newValue }
        get { return center.x }
    }
    
    /// UIView - 中心点 y
    public var jjc_centerY: CGFloat {
        set { center.y = newValue }
        get { return center.y }
    }
    
    /// UIView - 距离左侧间距 x
    public var jjc_x: CGFloat {
        set { frame.origin.x = newValue }
        get { return frame.origin.x }
    }

    /// UIView - 距离顶部间距 y
    public var jjc_y: CGFloat {
        set { frame.origin.y = newValue }
        get { return frame.origin.y }
    }
    
    /// UIView - 宽度
    public var jjc_width: CGFloat {
        set { frame.size.width = newValue }
        get { return frame.size.width }
    }
    
    /// UIView - 高度
    public var jjc_height: CGFloat {
        set { frame.size.height = newValue }
        get { return frame.size.height }
    }
    
    /// UIView - 左上角坐标
    public var jjc_origin: CGPoint {
        set { frame.origin = newValue }
        get { return frame.origin }
    }
    
    /// UIView - 宽高尺寸
    public var jjc_size: CGSize {
        set { frame.size = newValue }
        get { return frame.size }
    }
}

// MARK: - 扩展 UIView 圆角、边框、阴影相关方法
extension UIView {
    /// UIView - 设置圆角、边框、阴影：radius、borderWidth、borderColor、shadowColor、shadowOffset、shadowOpacity、shadowRadius
    public func jjc_radiusBorderShadow(radius: CGFloat,
                                       border: (width: CGFloat?, color: UIColor?)?,
                                       shadow: (color: UIColor?, offset: CGSize?, opacity: Float?, radius: CGFloat?)?) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        if let borderWidth = border?.width {
            layer.borderWidth = borderWidth
        }
        if let borderColor = border?.color {
            layer.borderColor = borderColor.cgColor
        }
        if shadow != nil {
            layer.masksToBounds = false
            if let shadowColor = shadow?.color {
                layer.shadowColor = shadowColor.cgColor
            }
            if let shadowOffset = shadow?.offset {
                layer.shadowOffset = shadowOffset
            }
            if let shadowOpacity = shadow?.opacity {
                layer.shadowOpacity = shadowOpacity
            }
            if let shadowRadius = shadow?.radius {
                layer.shadowRadius = shadowRadius
            }
        }
    }
    
    /// UIView - 设置圆角、边框：radius、borderWidth、borderColor
    public func jjc_radiusBorder(radius: CGFloat,
                                 border: (width: CGFloat?, color: UIColor?)?) {
        jjc_radiusBorderShadow(radius: radius, border: border, shadow: nil)
    }
    
    /// UIView - 设置圆角：radius
    public func jjc_radius(radius: CGFloat) {
        jjc_radiusBorderShadow(radius: radius, border: nil, shadow: nil)
    }
}

// MARK: - 检测
extension UIView {
    /// UIView - 检测第一响应者控件
    public func jjc_findFirstResponder() -> UIView? {
        guard !isFirstResponder else { return self }
        for subView in subviews {
            if let firstResponder = subView.jjc_findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}

// MARK: - 子元素操作
extension UIView {
    /// UIView - 移除所有子元素
    public func jjc_removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
}
