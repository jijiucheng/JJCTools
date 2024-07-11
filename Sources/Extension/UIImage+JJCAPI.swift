//
//  UIImage+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/7/28.
//

import Foundation
import UIKit

// MARK: - UIImage 图片生成
extension UIImage {
    /// UIImage - 初始化 图片名称
    /// - `bundle` 和 `objClass`
    ///   - 是用于获取 `mainBundle（Bundle.main）` 的，主要是用于区分是获取主工程的资源文件，还是子工程的资源文件；
    ///   - bundle 参数获取 mainBundle 优先级高于通过 objClass 参数获取 mainBundle；
    public convenience init?(name: String, bundle: Bundle? = nil, objClass: AnyClass? = nil) {
        var mainBundle = Bundle.main
        if let tempObjClass = objClass {
            mainBundle = Bundle(for: tempObjClass)
        }
        if let tempBundle = bundle {
            mainBundle = tempBundle
        }
        if mainBundle.isEqual(Bundle.main) {
            self.init(named: name)
        } else {
            self.init(named: name, in: mainBundle, compatibleWith: nil)
        }
    }
}

// MARK: - UIImage 转换方法
extension UIImage {
    /// UIImage - 图片转 String
    public func jjc_toBase64String(_ isPNG: Bool? = false) -> String? {
        if let data: Data = (isPNG ?? false) ? self.pngData() : self.jpegData(compressionQuality: 1.0) {
            return data.base64EncodedString(options: .lineLength64Characters)
        }
        return nil
    }
    
    /// UIImage - 颜色转图片
    public static func jjc_getImage(color: UIColor?) -> UIImage? {
        if let newColor = color {
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(newColor.cgColor)
            context!.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    /// UIImage - 根据 UIView 生成图片
    public static func jjc_getImage(view: UIView?) -> UIImage? {
        if let newView = view {
            UIGraphicsBeginImageContext(newView.bounds.size)
            newView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
}
