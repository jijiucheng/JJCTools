//
//  JJCTheme.swift
//  JJCTools
//
//  Created by mxgx on 2023/6/19.
//

import UIKit
import Foundation

public enum JJCThemeMode: Int {
    case light = 0      // 浅色模式
    case dark           // 深色模式
    case system         // 跟随系统
    case custom         // 自定义
}

public struct JJCThemeModel {
    public var mode: JJCThemeMode = .light                             // 模式类型
    public var modeName: String = JJC_Local("Theme_light", "浅色模式")  // 模式名称
    public var modeColor: UIColor = .white                             // 模式颜色（用于让用户直观是那种主题色）
    public var themeColor: UIColor = UIColor(hexString: "#60D0C4")     // 主题色
    public var vcBgColor: UIColor = UIColor(hexString: "#F0F0F0")      // 背景色
    public var lineColor: UIColor = UIColor(hexString: "#DCDCDC")      // 线条颜色
    public var mainTitleColor: UIColor = .black                        // 主标题颜色
    public var subTitleColor: UIColor = .darkGray                      // 副标题颜色
    public var otherTitleColor: UIColor = .lightGray                   // 其它文本颜色
    public var maskTitleColor: UIColor = .white                        // 蒙层文本颜色
    public var sourceColor: UIColor = .red                             // 源颜色
    public var lastChapterColor: UIColor = .orange                     // 最新章节颜色
    public var otherColors = [String: UIColor]()                       // 其它扩展颜色
}

open class JJCTheme: NSObject {
    /// JJCTheme - 单例
    public static let shared = JJCTheme()
    
    /// JJCTheme - 当前主题模型数据
    fileprivate var themes = [JJCThemeModel]()
    /// JJCTheme - 当前选中模式
    public var curTheme = JJCThemeModel()
    /// JJCTheme - 浅色模式数据
    open var lightTheme: JJCThemeModel = {
        var model = JJCThemeModel()
        model.mode = .light
        model.modeName = JJC_Local("Theme_light", "浅色模式")
        model.modeColor = .white
        model.themeColor = UIColor(hexString: "#60D0C4")
        model.vcBgColor = UIColor(hexString: "#F0F0F0")
        model.lineColor = UIColor(hexString: "#DCDCDC")
        model.mainTitleColor = .black
        model.subTitleColor = .darkGray
        model.otherTitleColor = .lightGray
        model.maskTitleColor = .white
        model.sourceColor = .red
        model.lastChapterColor = .orange
        model.otherColors = [String: UIColor]()
        return model
    }()
    /// JJCTheme - 深色模式数据
    open var darkTheme: JJCThemeModel = {
        var model = JJCThemeModel()
        model.mode = .dark
        model.modeName = JJC_Local("Theme_dark", "深色模式")
        model.modeColor = .black
        model.themeColor = UIColor(hexString: "#60D0C4")
        model.vcBgColor = .black
        model.lineColor = UIColor(hexString: "#DCDCDC")
        model.mainTitleColor = .white
        model.subTitleColor = .lightText
        model.otherTitleColor = .lightGray
        model.maskTitleColor = .lightText
        model.sourceColor = .red
        model.lastChapterColor = .orange
        model.otherColors = [String: UIColor]()
        return model
    }()
    
    override init() {
        super.init()
        themes = [lightTheme, darkTheme, jjc_systemTheme()]
        curTheme = lightTheme
    }
}

extension JJCTheme {
    /// JJCTheme - 跟随系统数据
    public func jjc_systemTheme() -> JJCThemeModel {
        var model = jjc_curThemeMode() == .dark ? darkTheme : lightTheme
        model.mode = .system
        model.modeName = JJC_Local("Theme_system", "跟随系统")
        return model
    }
    
    /// JJCTheme - 获取所有主题数据
    public func jjc_themes() -> [JJCThemeModel] {
        // 优先检查数据的正确性（主要是因为部分参数允许重载引起的）
        var tempArray = [JJCThemeModel]()
        for (index, var item) in themes.enumerated() {
            if index == 0 {
                item.mode = .light
                item.modeName = JJC_Local("Theme_light", "浅色模式")
            } else if index == 1 {
                item.mode = .dark
                item.modeName = JJC_Local("Theme_dark", "深色模式")
            } else if index == 2 {
                item.mode = .system
                item.modeName = JJC_Local("Theme_system", "跟随系统")
            } else {
                item.mode = .custom
            }
            tempArray.append(item)
        }
        themes = tempArray
        return themes
    }
    
    /// JJCTheme - 新增主题模式
    public func jjc_addTheme(_ theme: JJCThemeModel) {
        var tempModel = theme
        tempModel.mode = .custom
        themes.append(tempModel)
    }
    
    /// JJCTheme - 删除某个主题模式
    public func jjc_deleteTheme(_ index: Int) {
        themes.remove(at: index)
    }
    
    /// JJCTheme - 切换主题模式
    public func jjc_switchTheme(_ index: Int) -> JJCThemeModel {
        if themes.count > index {
            curTheme = themes[index]
        }
        return curTheme
    }
}

// MARK: - 更改系统控件颜色
extension JJCTheme {
    /// JJCTheme - 获取当前浅色、深色模式类型
    public func jjc_curThemeMode() -> UIUserInterfaceStyle {
        return UITraitCollection.current.userInterfaceStyle
    }

    /// JJCAPI - 切换浅色、深色模式
    public func jjc_themeMode(_ style: UIUserInterfaceStyle) {
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

// MARK: - 获取图片
extension JJCTheme {
    public func jjc_image_back() -> UIImage {
        return JJC_Image("base_back", isModule: true) ?? UIImage()
    }
    
    public func jjc_image_search() -> UIImage {
        return JJC_Image("base_search", isModule: true) ?? UIImage()
    }
    
    public func jjc_image_setting() -> UIImage {
        return JJC_Image("base_setting", isModule: true) ?? UIImage()
    }
}

// MARK: - 获取颜色
extension JJCTheme {
    public func jjc_color_statusNavi() -> UIColor {
        return JJC_Color("base_statusNaviColor", isModule: true) ?? .white
    }
    
    public func jjc_color_naviShadow() -> UIColor {
        return JJC_Color("base_naviShadowColor", isModule: true) ?? UIColor(hexString: "#DCDCDC")
    }
    
    public func jjc_color_controller() -> UIColor {
        return JJC_Color("base_controllerColor", isModule: true) ?? UIColor(hexString: "#FFFFFF")
    }
    
    public func jjc_color_view() -> UIColor {
        return JJC_Color("base_viewColor", isModule: true) ?? UIColor(hexString: "#FFFFFF")
    }
    
    public func jjc_color_line() -> UIColor {
        return JJC_Color("base_lineColor", isModule: true) ?? UIColor(hexString: "#DCDCDC")
    }
}
