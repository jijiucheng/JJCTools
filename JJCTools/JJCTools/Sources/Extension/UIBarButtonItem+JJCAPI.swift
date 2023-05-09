//
//  UIBarButtonItem+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/9/14.
//

import Foundation
import UIKit

// MARK: - UIBarButtonItem 扩展存储属性
extension UIBarButtonItem {
    /// UIBarButtonItem -
    private struct AssociatedKey {
        static var itemWidth: CGFloat = 30.0
        static var itemHeight: CGFloat = 30.0
    }
    
    /// UIBarButtonItem - 导航栏按钮宽度
    public var jjc_itemWidth: CGFloat {
        get { return objc_getAssociatedObject(self, &AssociatedKey.itemWidth) as? CGFloat ?? 0 }
        set { objc_setAssociatedObject(self, &AssociatedKey.itemWidth, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    /// UIBarButtonItem - 导航栏按钮高度
    public var jjc_itemHeight: CGFloat {
        get { return objc_getAssociatedObject(self, &AssociatedKey.itemHeight) as? CGFloat ?? 0 }
        set { objc_setAssociatedObject(self, &AssociatedKey.itemHeight, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
}

// MARK: - UIBarButtonItem 扩展方法
extension UIBarButtonItem {
    /// UIBarButtonItem - 核心方法 - 初始化导航栏按钮（图片）
    public static func jjc_params(frame: CGRect? = nil,
                                  image: UIImage,
                                  contentInsets: UIEdgeInsets? = nil,
                                  horizontalAlignment: UIControl.ContentHorizontalAlignment? = nil,
                                  target: Any?,
                                  action: Selector) -> UIBarButtonItem {
        /**
        customView 类型，需要传递的是 view，才可以控制 btn 的大小尺寸
        https://www.jianshu.com/p/ba796cf1c15f
        */
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        if let buttonViewFrame = frame {
            buttonView.frame = buttonViewFrame
        }

        let button = UIButton(type: .custom)
        button.frame = buttonView.bounds
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        if let newContentInsets = contentInsets {
            button.imageEdgeInsets = newContentInsets
        }
        if let newHorizontalAlignment = horizontalAlignment {
            button.contentHorizontalAlignment = newHorizontalAlignment
        }
        button.addTarget(target, action: action, for: .touchUpInside)
        buttonView.addSubview(button)
    
        return UIBarButtonItem(customView: buttonView)
    }
    
    /// UIBarButtonItem - 核心方法 - 初始化导航栏按钮（文字）
    public static func jjc_params(frame: CGRect? = nil,
                                  title: String,
                                  color: UIColor,
                                  font: UIFont,
                                  selectTitle: String? = nil,
                                  selectColor: UIColor? = nil,
                                  contentInsets: UIEdgeInsets? = nil,
                                  horizontalAlignment: UIControl.ContentHorizontalAlignment? = nil,
                                  target: Any?,
                                  action: Selector) -> UIBarButtonItem {
        
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        if let buttonViewFrame = frame {
            buttonView.frame = buttonViewFrame
        }

        let button = UIButton(type: .custom)
        button.frame = buttonView.bounds
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = font
        button.setTitle(selectTitle ?? title, for: .selected)
        button.setTitleColor(selectColor ?? color, for: .selected)
        if let newContentInsets = contentInsets {
            button.titleEdgeInsets = newContentInsets
        }
        if let newHorizontalAlignment = horizontalAlignment {
            button.contentHorizontalAlignment = newHorizontalAlignment
        }
        button.addTarget(target, action: action, for: .touchUpInside)
        buttonView.addSubview(button)
    
        return UIBarButtonItem(customView: buttonView)
    }
}

// MARK: - UIBarButtonItem 扩展方法
extension UIBarButtonItem {
    /// UIBarButtonItem - 简版 - 初始化导航栏按钮（默认）
    public class func jjc_paramsByCustom(_ isRight: Bool = false, image: UIImage, target: Any?, action: Selector) -> UIBarButtonItem {
        let frame = CGRect(x: isRight ? 5 : -5, y: 0, width: 30, height: 30)
        let insets = UIEdgeInsets(top: 0, left: isRight ? 5 : -5, bottom: 0, right: isRight ? -5 : 5)
        return jjc_params(frame: frame, image: image, contentInsets: insets, horizontalAlignment: isRight ? .right : .left, target: target, action: action)
    }
    
    /// UIBarButtonItem - 简版 - 初始化导航栏文字按钮
    public class func jjc_paramsByCustom(_ isRight: Bool = false, title: String, color: UIColor = .darkGray, selectTitle: String? = nil, selectColor: UIColor? = nil, target: Any?, action: Selector) -> UIBarButtonItem {
        let frame = CGRect(x: isRight ? -5 : 5, y: 0, width: 45, height: 30)
        let insets = UIEdgeInsets(top: 0, left: isRight ? -5 : 5, bottom: 0, right: isRight ? 5 : -5)
        let font = (title.count > (JJCLocal.jjc_isChinese(JJC_mainBundleByJJCTools).isChinese ? 3 : 6)) ? UIFont.systemFont(ofSize: 11) : UIFont.systemFont(ofSize: 14)
        return jjc_params(frame: frame, title: title, color: color, font: font, selectTitle: selectTitle, selectColor: selectColor, contentInsets: insets, horizontalAlignment: isRight ? .right : .left, target: target, action: action)
    }
}
