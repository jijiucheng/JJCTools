//
//  JJCTheme.swift
//  JJCTools
//
//  Created by mxgx on 2023/6/19.
//

import UIKit
import Foundation

public enum JJCThemeColor: String {
    case theme = "ThemeColor"                           // 主题色
    case status = "StatusColor"                         // 状态栏背景色
    case navigationBar = "NavigationBarColor"           // 导航栏背景色
    case navigationShadow = "NavigationShadowColor"     // 导航栏底部线条颜色
    case controller = "ControllerColor"                 // 控制器背景色
    case view = "ViewColor"                             // 组件背景色
    case line = "LineColor"                             // 线条颜色
    case mainTitle = "MainTitleColor"                   // 主标题颜色
    case subTitle = "SubTitleColor"                     // 副标题颜色
    case otherTitle = "OtherTitleColor"                 // 其它标题颜色
    case maskTitle = "MaskTitleColor"                   // 蒙层标题颜色
    case sourceTitle = "SourceTitleColor"               // 源标题颜色
    case lastChapter = "LastChapterColor"               // 最新章节颜色
}

public typealias JJCThemeColorParams = (key: JJCThemeColor, name: String, unspecified: String, light: String, dark: String)
public func JJC_ThemeColor(_ key: JJCThemeColor, update: JJCThemeColorParams? = nil) -> UIColor {
    return JJCTheme.shared.jjc_color(key, update: update)
}


open class JJCTheme: NSObject {
    /// JJCTheme - 单例
    public static let shared = JJCTheme()
    
    /// 主题模式类型
    public let modes: [(mode: UIUserInterfaceStyle, name: String)] = {
        return [(.unspecified, JJC_Local("Theme_system", "跟随系统", objClass: JJCGlobalClass.self)),
                (.light, JJC_Local("Theme_light", "浅色模式", objClass: JJCGlobalClass.self)),
                (.dark, JJC_Local("Theme_system", "跟随系统", objClass: JJCGlobalClass.self))]
    }()
    /// 默认颜色数组
    public let defaultColors: [JJCThemeColorParams] = {
        var colors = [JJCThemeColorParams]()
        colors.append((.theme, "主题色", "#60D0C4", "#60D0C4", "#60D0C4"))
        colors.append((.status, "状态栏背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((.navigationBar, "导航栏背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((.navigationShadow, "导航栏底部线条颜色", "#DCDCDC", "#DCDCDC", "#DCDCDC_0.30"))
        colors.append((.controller, "控制器背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((.view, "组件背景色", "#FFFFFF", "#FFFFFF", "#111111"))
        colors.append((.line, "线条颜色", "#DCDCDC", "#DCDCDC", "#DCDCDC"))
        colors.append((.mainTitle, "主标题颜色", "#000000", "#000000", "#FFFFFF"))
        colors.append((.subTitle, "副标题颜色", "#353535", "#353535", "#EEEEEE"))
        colors.append((.otherTitle, "其它标题颜色", "#898989", "#898989", "#999999"))
        colors.append((.maskTitle, "蒙层标题颜色", "#FFFFFF", "#FFFFFF", "#FFFFFF"))
        colors.append((.sourceTitle, "源标题颜色", "#FF0000", "#FF0000", "#FF0000"))
        colors.append((.lastChapter, "最新章节颜色", "#FFA500", "#FFA500", "#FFA500"))
        return colors
    }()
    /// 自定义颜色数组
    public var customColors = [JJCThemeColorParams]()
    
    override init() {
        super.init()
        customColors = defaultColors
    }
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
    
    /// JJCTheme - 校验新设置的色值合法性
    fileprivate func jjc_checkColor(_ value: String) -> (isUpdate: Bool, value: String) {
        let tempValue = value.uppercased()
        if tempValue.count == 7, let first = tempValue.jjc_getRegexStrings("#[A-F0-9]{6}").first {
            return (true, first)
        } else if tempValue.count == 12, let first = tempValue.jjc_getRegexStrings("#[A-F0-9]{6}_([0][.][0-9]{2})").first {
            return (true, first)
        } else {
            return (false, tempValue)
        }
    }
    
    /// JJCTheme - 根据 key 获取或更新所需的颜色
    public func jjc_color(_ key: JJCThemeColor, update: JJCThemeColorParams? = nil) -> UIColor {
        var keyIndex = 0
        var keyItem: JJCThemeColorParams = (key, "", "", "", "")
        for (index, item) in customColors.enumerated() where item.key == key {
            keyIndex = index
            keyItem = item
            break
        }
        if let tempUpdate = update {
            keyItem.unspecified = jjc_checkColor(tempUpdate.unspecified).isUpdate ? tempUpdate.unspecified : keyItem.unspecified
            keyItem.light = jjc_checkColor(tempUpdate.light).isUpdate ? tempUpdate.light : keyItem.light
            keyItem.dark = jjc_checkColor(tempUpdate.dark).isUpdate ? tempUpdate.dark : keyItem.dark
            customColors[keyIndex] = keyItem
        }
        
        let unspecified: UIColor = UIColor(hexString: jjc_getColorValueAndAlpha(keyItem.unspecified).color, alpha: jjc_getColorValueAndAlpha(keyItem.unspecified).alpha)
        let light: UIColor = UIColor(hexString: jjc_getColorValueAndAlpha(keyItem.light).color, alpha: jjc_getColorValueAndAlpha(keyItem.light).alpha)
        let dark: UIColor = UIColor(hexString: jjc_getColorValueAndAlpha(keyItem.dark).color, alpha: jjc_getColorValueAndAlpha(keyItem.dark).alpha)
        return jjc_getDynamicColor(unspecified, light, dark)
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
