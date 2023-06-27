//
//  JJCTheme.swift
//  JJCTools
//
//  Created by mxgx on 2023/6/19.
//

import UIKit
import Foundation

open class JJCTheme: NSObject {
    /// JJCTheme - 单例
    public static let shared = JJCTheme()
    
    /// 主题模式类型
    public let modes: [(mode: UIUserInterfaceStyle, name: String)] = {
        return [(.unspecified, JJC_Local("Theme_system", "跟随系统", objClass: JJCGlobalClass.self)),
                (.light, JJC_Local("Theme_light", "浅色模式", objClass: JJCGlobalClass.self)),
                (.dark, JJC_Local("Theme_system", "跟随系统", objClass: JJCGlobalClass.self))]
    }()
}

// MARK: - 获取图片
extension JJCTheme {
    public func jjc_image_back() -> UIImage {
        return JJC_Image("base_back", objClass: JJCGlobalClass.self) ?? UIImage()
    }
    
    public func jjc_image_search() -> UIImage {
        return JJC_Image("base_search", objClass: JJCGlobalClass.self) ?? UIImage()
    }
    
    public func jjc_image_setting() -> UIImage {
        return JJC_Image("base_setting", objClass: JJCGlobalClass.self) ?? UIImage()
    }
}

// MARK: - 获取颜色
extension JJCTheme {
    /// UIColor - 动态颜色（暗黑模式适配）
    public func jjc_color_dynamic(any: UIColor, light: UIColor? = nil, dark: UIColor) -> UIColor {
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
    
    public func jjc_color_statusNavi() -> UIColor {
        return JJC_Color("base_statusNaviColor", objClass: JJCGlobalClass.self) ?? .white
    }
    
    public func jjc_color_naviShadow() -> UIColor {
        return JJC_Color("base_naviShadowColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#DCDCDC")
    }
    
    public func jjc_color_controller() -> UIColor {
        return JJC_Color("base_controllerColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#FFFFFF")
    }
    
    public func jjc_color_view() -> UIColor {
        return JJC_Color("base_viewColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#FFFFFF")
    }
    
    public func jjc_color_line() -> UIColor {
        return JJC_Color("base_lineColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#DCDCDC")
    }
    
    public func jjc_color_mainTitle() -> UIColor {
        return JJC_Color("base_mainTitleColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#000000")
    }
    
    public func jjc_color_subTitle() -> UIColor {
        return JJC_Color("base_subTitleColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#353535")
    }
    
    public func jjc_color_otherTitle() -> UIColor {
        return JJC_Color("base_otherTitleColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#898989")
    }
    
    public func jjc_color_maskTitle() -> UIColor {
        return JJC_Color("base_maskTitleColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#FFFFFF")
    }
    
    public func jjc_color_source() -> UIColor {
        return JJC_Color("base_sourceColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#FF0000")
    }
    
    public func jjc_color_lastChapter() -> UIColor {
        return JJC_Color("base_lastChapterColor", objClass: JJCGlobalClass.self) ?? UIColor(hexString: "#FFA500")
    }
}

// MARK: - 更改系统控件颜色
extension JJCTheme {
    /// JJCTheme - 获取当前浅色、深色模式类型
    public func jjc_curTheme() -> UIUserInterfaceStyle {
        return UITraitCollection.current.userInterfaceStyle
    }

    /// JJCAPI - 切换浅色、深色模式
    public func jjc_switchTheme(_ style: UIUserInterfaceStyle) {
        JJC_KeyWindow()?.overrideUserInterfaceStyle = style
    }
    
    /// JJCTheme - 更改状态栏背景色
    public func jjc_setStatusColor(_ color: UIColor) {
        if let rect = JJC_KeyWindow()?.windowScene?.statusBarManager?.statusBarFrame {
            let statusV = UIView(frame: rect)
            JJC_KeyWindow()?.addSubview(statusV)
            statusV.backgroundColor = color
        }
    }
    
    /// JJCTheme - 更改导航栏背景色
    public func jjc_setNavigationBarColor(_ color: UIColor, controller: UIViewController) {
        // 虽然可以更改背景色，但是有透明效果，且界面有滚动的情况，颜色会消失
//        controller.navigationController?.navigationBar.backgroundColor = color
        // 虽然可以更改背景色，但是有透明效果，且最开始渲染的时候没有更改颜色，只有界面滚动的情况才有更改颜色
        controller.navigationController?.navigationBar.barTintColor = color
        // 去除透明效果，但是会使 View 整体向下偏移 (状态栏 + 导航栏) 的高度
        controller.navigationController?.navigationBar.isTranslucent = false
    }
}
