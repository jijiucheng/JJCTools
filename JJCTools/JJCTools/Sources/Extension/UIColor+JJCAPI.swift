//
//  UIColor+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/7/28.
//

import Foundation
import UIKit

// MARK: - 便利构造 UIColor 方法
extension UIColor {
    /// UIColor - 获取十六进制字符串 UIColor -> Hex String
    public var jjc_hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        if alpha == 1.0 {
            return String(format: "#%02lX%02lX%02lX",
                          Int(red * multiplier),
                          Int(green * multiplier),
                          Int(blue * multiplier))
        } else {
            return String(format: "#%02lX%02lX%02lX%02lX",
                          Int(red * multiplier),
                          Int(green * multiplier),
                          Int(blue * multiplier),
                          Int(alpha * multiplier))
        }
    }
    
    /// UIColor - 初始化 RGBA 颜色，无需输入 255
    public convenience init(rgba255 red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat? = 1.0) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha ?? 1.0)
    }
    
    /// UIColor - 初始化 十六进制颜色
    public convenience init(hexString: String, alpha: CGFloat? = 1.0) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        var color: UInt64 = 0
        let scanner = Scanner(string: hexString)
        scanner.scanHexInt64(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: alpha ?? 1.0)
    }
    
    /// UIColor - 初始化 颜色名称
    public convenience init?(name: String, bundle: Bundle? = nil) {
        if let mainBundle = bundle {
            self.init(named: name, in: mainBundle, compatibleWith: nil)
        } else {
            self.init(named: name)
        }
    }
}

// MARK: - UIColor 扩展方法
extension UIColor {
    /// UIColor - 动态颜色（暗黑模式适配）
    public static func jjc_dynamicColor(any: UIColor, light: UIColor? = nil, dark: UIColor) -> UIColor {
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            } else if traitCollection.userInterfaceStyle == .light {
                return light ?? any
            } else {
                return any
            }
        }
    }
    
    /// UIColor - 判断两个颜色是否相同
    public static func jjc_isEqual(_ colorA: UIColor, _ colorB: UIColor) -> Bool {
        return colorA.isEqual(colorB)
    }
}

// MARK: - UIColor 转换方法
extension UIColor {
    /// UIColor - 颜色转图片
    public func jjc_toImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - 常用颜色
extension UIColor {
    /// UIColor - 状态栏导航栏背景色
    public static func jjc_statusNaviColor() -> UIColor {
        return UIColor(name: "base_statusNaviColor", bundle: Bundle(for: JJCGlobalClass.self)) ?? .white
    }
    
    /// UIColor - 控制器背景色
    public static func jjc_controllerColor() -> UIColor {
        return UIColor(name: "base_controllerColor", bundle: Bundle(for: JJCGlobalClass.self)) ?? UIColor(hexString: "#FFFFFF")
    }
    
    /// UIColor - 普通 View 背景色
    public static func jjc_viewColor() -> UIColor {
        return UIColor(name: "base_viewColor", bundle: Bundle(for: JJCGlobalClass.self)) ?? UIColor(hexString: "#FFFFFF")
    }
    
    /// UIColor - 线条颜色（#DCDCDC - 220,220,220）
    public static func jjc_lineColor() -> UIColor {
        return UIColor(name: "base_lineColor", bundle: Bundle(for: JJCGlobalClass.self)) ?? UIColor(hexString: "#DCDCDC")
    }
}
