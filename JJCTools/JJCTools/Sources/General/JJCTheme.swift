//
//  JJCTheme.swift
//  JJCTools
//
//  Created by mxgx on 2023/6/19.
//

import UIKit
import Foundation

fileprivate let ThemeColor = "ThemeColor"
fileprivate let StatusColor = "StatusColor"
fileprivate let NavigationBarColor = "NavigationBarColor"
fileprivate let NavigationShadowColor = "NavigationShadowColor"
fileprivate let ControllerColor = "ControllerColor"
fileprivate let ViewColor = "ViewColor"
fileprivate let LineColor = "LineColor"
fileprivate let MainTitleColor = "MainTitleColor"
fileprivate let SubTitleColor = "SubTitleColor"
fileprivate let OtherTitleColor = "OtherTitleColor"
fileprivate let MaskTitleColor = "MaskTitleColor"
fileprivate let SourceColor = "SourceColor"
fileprivate let LastChapterColor = "LastChapterColor"

open class JJCTheme: NSObject {
    /// JJCTheme - 单例
    public static let shared = JJCTheme()
    
    /// 主题模式类型
    public let modes: [(mode: UIUserInterfaceStyle, name: String)] = {
        return [(.unspecified, JJC_Local("Theme_system", "跟随系统", objClass: JJCGlobalClass.self)),
                (.light, JJC_Local("Theme_light", "浅色模式", objClass: JJCGlobalClass.self)),
                (.dark, JJC_Local("Theme_system", "跟随系统", objClass: JJCGlobalClass.self))]
    }()
    public typealias JJCThemeColorParams = (key: String, name: String, unspecified: String, light: String, dark: String)
    /// 默认颜色数组
    public let defaultColors: [JJCThemeColorParams] = {
        var colors = [JJCThemeColorParams]()
        colors.append((ThemeColor, "主题色", "#60D0C4", "#60D0C4", "#60D0C4"))
        colors.append((StatusColor, "状态栏背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((NavigationBarColor, "导航栏背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((NavigationShadowColor, "导航栏底部线条颜色", "#DCDCDC", "#DCDCDC", "#111111_0.3"))
        colors.append((ControllerColor, "控制器背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((ViewColor, "组件背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((LineColor, "线条颜色", "#DCDCDC", "#DCDCDC", "#DCDCDC"))
        colors.append((MainTitleColor, "主标题颜色", "#000000", "#000000", "#FFFFFF"))
        colors.append((SubTitleColor, "副标题颜色", "#353535", "#353535", "#EEEEEE"))
        colors.append((OtherTitleColor, "其它标题颜色", "#898989", "#898989", "#999999"))
        colors.append((MaskTitleColor, "蒙层标题颜色", "#FFFFFF", "#FFFFFF", "#FFFFFF"))
        colors.append((SourceColor, "源标题颜色", "#FF0000", "#FF0000", "#FF0000"))
        colors.append((LastChapterColor, "最新章节颜色", "#FFA500", "#FFA500", "#FFA500"))
        return colors
    }()
    /// 自定义颜色数组
    public var customColors: [JJCThemeColorParams] = {
        var colors = [JJCThemeColorParams]()
        colors.append((ThemeColor, "主题色", "#60D0C4", "#60D0C4", "#60D0C4"))
        colors.append((StatusColor, "状态栏背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((NavigationBarColor, "导航栏背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((NavigationShadowColor, "导航栏底部线条颜色", "#DCDCDC", "#DCDCDC", "#111111_0.3"))
        colors.append((ControllerColor, "控制器背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((ViewColor, "组件背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((LineColor, "线条颜色", "#DCDCDC", "#DCDCDC", "#DCDCDC"))
        colors.append((MainTitleColor, "主标题颜色", "#000000", "#000000", "#FFFFFF"))
        colors.append((SubTitleColor, "副标题颜色", "#353535", "#353535", "#EEEEEE"))
        colors.append((OtherTitleColor, "其它标题颜色", "#898989", "#898989", "#999999"))
        colors.append((MaskTitleColor, "蒙层标题颜色", "#FFFFFF", "#FFFFFF", "#FFFFFF"))
        colors.append((SourceColor, "源标题颜色", "#FF0000", "#FF0000", "#FF0000"))
        colors.append((LastChapterColor, "最新章节颜色", "#FFA500", "#FFA500", "#FFA500"))
        return colors
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
    /// JJCTheme - 动态颜色（暗黑模式适配）
    public func jjc_getDynamicColor(_ any: UIColor, _ light: UIColor? = nil, _ dark: UIColor) -> UIColor {
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
    
    /// JJCTheme - 根据颜色值字符串获取色值和透明度
    fileprivate func jjc_getColorValueAndAlpha(_ value: String) -> (color: String, alpha: CGFloat) {
        guard value.jjc_isNotEmptyOrValid() else { return ("#000000", 1) }
        let array = value.components(separatedBy: "_")
        if array.count > 1 {
            return (array[0], CGFloat(Double(array[1]) ?? 1))
        } else {
            return (array[0], 1)
        }
    }
    
    /// JJCTheme - 根据 key 获取所需的颜色
    public func jjc_getColor(_ key: String) -> UIColor {
        var params: JJCThemeColorParams = (key, "", "", "", "")
        for item in customColors where item.key == key {
            params = item
            break
        }
        let unspecified: UIColor = UIColor(hexString: jjc_getColorValueAndAlpha(params.unspecified).color, alpha: jjc_getColorValueAndAlpha(params.unspecified).alpha)
        var light: UIColor = UIColor(hexString: jjc_getColorValueAndAlpha(params.light).color, alpha: jjc_getColorValueAndAlpha(params.light).alpha)
        var dark: UIColor = UIColor(hexString: jjc_getColorValueAndAlpha(params.dark).color, alpha: jjc_getColorValueAndAlpha(params.dark).alpha)
        return jjc_getDynamicColor(unspecified, light, dark)
    }
    
    /// JJCTheme - 主题色
    public func jjc_color_theme() -> UIColor {
        return jjc_getColor(ThemeColor)
    }
    
    /// JJCTheme - 状态栏背景色
    public func jjc_color_status() -> UIColor {
        return jjc_getColor(StatusColor)
    }
    
    /// JJCTheme - 导航栏背景色
    public func jjc_color_navigationBar() -> UIColor {
        return jjc_getColor(NavigationBarColor)
    }
    
    /// JJCTheme - 导航栏底部线条颜色
    public func jjc_color_naviShadow() -> UIColor {
        return jjc_getColor(NavigationShadowColor)
    }
    
    /// JJCTheme - 控制器背景色
    public func jjc_color_controller() -> UIColor {
        return jjc_getColor(ControllerColor)
    }
    
    /// JJCTheme - 组件背景色
    public func jjc_color_view() -> UIColor {
        return jjc_getColor(ViewColor)
    }
    
    /// JJCTheme - 线条颜色
    public func jjc_color_line() -> UIColor {
        return jjc_getColor(LineColor)
    }
    
    /// JJCTheme - 主标题颜色
    public func jjc_color_mainTitle() -> UIColor {
        return jjc_getColor(MainTitleColor)
    }
    
    /// JJCTheme - 副标题颜色
    public func jjc_color_subTitle() -> UIColor {
        return jjc_getColor(SubTitleColor)
    }
    
    /// JJCTheme - 其它标题颜色
    public func jjc_color_otherTitle() -> UIColor {
        return jjc_getColor(OtherTitleColor)
    }
    
    /// JJCTheme -  状态栏背景色
    public func jjc_color_maskTitle() -> UIColor {
        return jjc_getColor(MaskTitleColor)
    }
    
    /// JJCTheme - 源标题颜色
    public func jjc_color_sourceTitle() -> UIColor {
        return jjc_getColor(SourceColor)
    }
    
    /// JJCTheme - 最新章节颜色
    public func jjc_color_lastChapter() -> UIColor {
        return jjc_getColor(LastChapterColor)
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
