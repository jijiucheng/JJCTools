//
//  JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/7/29.
//

import Foundation
import UIKit

public class JJCGlobalClass: NSObject {}

// MARK: - 全局常量
/// JJCAPI - 屏幕尺寸
public let JJC_ScreenSize = UIScreen.main.responds(to: #selector(getter: UIScreen.nativeBounds)) ? CGSize(width: UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale, height: UIScreen.main.nativeBounds.size.height / UIScreen.main.nativeScale) : UIScreen.main.bounds.size
/// JJCAPI - 屏幕宽度
public let JJC_ScreenW = JJC_ScreenSize.width
/// JJCAPI - 屏幕高度
public let JJC_ScreenH = JJC_ScreenSize.height
/// JJCAPI - 导航栏高度
public let JJC_NaviH: CGFloat = 44.0

/// JJCAPI - 基础间隙
public let JJC_Margin: CGFloat = 10

/// JJCAPI - 沙盒 Document 路径
public let JJC_DocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
/// JJCAPI - 沙盒 Cache 路径
public let JJC_CachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
/// JJCAPI - 沙盒 temp 路径
public let JJC_TempPath = NSTemporaryDirectory()

/// JJCAPI - 是否为 iPhone
public let JJC_IsIPhone = (UIDevice.current.userInterfaceIdiom == .phone)
/// JJCAPI - 是否为 iPad
public let JJC_IsIPad = (UIDevice.current.userInterfaceIdiom == .pad)
/// JJCAPI - 是否为 CarPlay
public let JJC_IsCarPlay = (UIDevice.current.userInterfaceIdiom == .carPlay)
/// JJCAPI - 判断当前设备是否横屏
public let JJC_IsLandScape = (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight)

/// JJCAPI - 系统信息 - JJCTools main bundle
public let JJC_mainBundleByJJCTools = Bundle(for: JJCGlobalClass.self)
/// JJCAPI - 系统信息 - App 唯一识别号
public let JJC_BundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
/// JJCAPI - 系统信息 - App 名称
public let JJC_BundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
/// JJCAPI - 系统信息 - release version
public let JJC_ReleaseVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
/// JJCAPI - 系统信息 - debug version
public let JJC_DebugVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
/// JJCAPI - 系统信息 - releaseVersion + debugVersion）【CFBundleShortVersionString + CFBundleVersion】
public let JJC_FullVersion = "\(JJC_ReleaseVersion)(\(JJC_DebugVersion))"


// MARK: - 全局函数
/// JJCAPI - 系统信息 - 版本 version 信息
public func JJC_Version() -> (release: String, debug: String, full: String) {
    return (JJC_ReleaseVersion, JJC_DebugVersion, JJC_FullVersion)
}

/// JJCAPI - Windows
/// - 参考资料：
///   - https://blog.csdn.net/u014651417/article/details/123423893
///   - http://events.jianshu.io/p/a74f593191d1
public func JJC_Windows() -> [UIWindow] {
    if #available(iOS 15.0, *) {
        return UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows ?? []
    } else {
        return UIApplication.shared.windows
    }
}

/// JJCAPI - KeyWindow
public func JJC_KeyWindow() -> UIWindow? {
    return JJC_Windows().first
}

/// JJCAPI - 是否是刘海屏
public func JJC_IsIPhoneX() -> Bool {
    if #available(iOS 11.0, *) {
        return JJC_KeyWindow()?.safeAreaInsets.bottom ?? 0 > 0
    } else {
        return false
    }
}

/// JJCAPI - 状态栏高度
public func JJC_StatusH() -> CGFloat {
    if #available(iOS 13.0, *) {
        return JJC_KeyWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}

/// JJCAPI - （状态栏+导航栏）高度
public func JJC_StatusNaviH() -> CGFloat {
    if #available(iOS 13.0, *) {
        return (JJC_KeyWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + JJC_NaviH
    } else {
        return UIApplication.shared.statusBarFrame.height + JJC_NaviH
    }
}

/// JJCAPI - 底部 TabBar 高度
public func JJC_TabBarH() -> CGFloat {
    return JJC_IsIPhoneX() ? (49.0 + 34.0) : 49.0
}

/// JJCAPI - 缩放比例(750*1334) px
public func JJC_IPhone6sRatio(_ padding: CGFloat) -> CGFloat {
    return CGFloat((JJC_IsIPad ? roundf(Float(padding * 0.5) * 1.5) : roundf(Float(padding) * 0.5)))
}

/// JJCAPI - 生成随机数
public func JJC_RandomNum(_ min: Int, _ max: Int) -> Int {
    return Int.random(in: min...max)
}

/// 生成随机字符串
/// https://www.cnblogs.com/strengthen/p/10091038.html
public func JJC_RandomString(_ length: Int, maxLength: Int = 25) -> String {
    var targetString = ""
    while targetString.count < maxLength {
        let random = arc4random() % 122
        if random > 96 {
            if let ascii = UnicodeScalar(random) {
                targetString += String(Character(ascii))
                if targetString.count == length {
                    break
                }
            }
        }
    }
    return targetString
}

// MARK: - 颜色
/// JJCAPI - 颜色 - RGBA
public func JJC_RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat? = 1.0) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: a ?? 1.0)
}

/// JJCAPI - 颜色 - RGBA_255
public func JJC_RGBA_255(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat? = 1.0) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255, blue: b / 255, alpha: a ?? 1.0)
}

/// JJCAPI - 颜色 - HexColorA
public func JJC_HexColorA(_ hexString: String, _ a: CGFloat? = 1.0) -> UIColor {
    return UIColor(hexString: hexString, alpha: a ?? 1.0)
}

/// JJCAPI - 颜色 - 获取动态颜色
public func JJC_DynamicColor(_ any: UIColor, _ light: UIColor? = nil, _ dark: UIColor) -> UIColor {
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

/// JJCAPI - 颜色 - Name（暗黑模式）
/// - `bundle` 和 `objClass`
///   - 是用于获取 `mainBundle（Bundle.main）` 的，主要是用于区分是获取主工程的资源文件，还是子工程的资源文件；
///   - bundle 参数获取 mainBundle 优先级高于通过 objClass 参数获取 mainBundle；
public func JJC_Color(_ name: String, bundle: Bundle? = nil, objClass: AnyClass? = nil) -> UIColor? {
    var mainBundle = Bundle.main
    if let tempObjClass = objClass {
        mainBundle = Bundle(for: tempObjClass)
    }
    if let tempBundle = bundle {
        mainBundle = tempBundle
    }
    if mainBundle.isEqual(Bundle.main) {
        return UIColor(named: name)
    } else {
        return UIColor(named: name, in: JJC_mainBundleByJJCTools, compatibleWith: nil)
    }
}

/// JJCAPI - 图片 - 获取图片资源
/// - `bundle` 和 `objClass`
///   - 是用于获取 `mainBundle（Bundle.main）` 的，主要是用于区分是获取主工程的资源文件，还是子工程的资源文件；
///   - bundle 参数获取 mainBundle 优先级高于通过 objClass 参数获取 mainBundle；
public func JJC_Image(_ name: String, bundle: Bundle? = nil, objClass: AnyClass? = nil) -> UIImage? {
    var mainBundle = Bundle.main
    if let tempObjClass = objClass {
        mainBundle = Bundle(for: tempObjClass)
    }
    if let tempBundle = bundle {
        mainBundle = tempBundle
    }
    if mainBundle.isEqual(Bundle.main) {
        return UIImage(named: name)
    } else {
        return UIImage(named: name, in: JJC_mainBundleByJJCTools, compatibleWith: nil)
    }
}

/// JJCAPI - 时间 - 获取指定时间信息
public func JJC_TimeInfo(_ date: Date? = nil, dateFormat: String? = nil) -> JJCTimeInfo {
    Date.jjc_timeInfo(date, dateFormat: dateFormat)
}

/// JJCAPI - 时间 - 获取当前时间信息
public func JJC_CurTimeInfo(_ dateFormat: String? = nil) -> JJCTimeInfo {
    return JJC_TimeInfo(Date(), dateFormat: dateFormat)
}

/// JJCAPI - 日志 - isLineBreak：最后一行是否添加换行，isModule 是否显示 framework 所属
public func JJC_Log<T>(_ log: T, file: String = #file, method: String = #function, line: Int = #line, isLineBreak: Bool = true, isModule: Bool = false) {
    print("\(isModule ? "[JJCTools] ": "")\(JJC_CurTimeInfo().time) <\((file as NSString).lastPathComponent)> [\(line)] \(method)：")
    print(log)
    if isLineBreak {
        print()
    }
}

// MARK: - 本地化
/// JJJCAPI - 本地语言 - 获取当前手机系统语言【设置->通用->语言->首选语言顺序】
/// - 此处也可以通过 UserDefaults.standard.value(forKey: "AppleLanguages") 获取
public func JJC_systemLanguage() -> String {
    return JJCLocal.jjc_systemLanguageInfo().systemLanguage
}

/// JJCAPI - 本地语言 - 获取当前语言环境（根据 Bundle 获取 lproj 的语言文件）
/// - `bundle` 和 `objClass`
///   - 是用于获取 `mainBundle（Bundle.main）` 的，主要是用于区分是获取主工程的资源文件，还是子工程的资源文件；
///   - bundle 参数获取 mainBundle 优先级高于通过 objClass 参数获取 mainBundle；
public func JJC_Language(_ bundle: Bundle? = nil, objClass: AnyClass? = nil) -> String {
    return JJCLocal.jjc_language(bundle, objClass: objClass)
}

/// JJCAPI - 本地语言 - 带注释
/// - `bundle` 和 `objClass`
///   - 是用于获取 `mainBundle（Bundle.main）` 的，主要是用于区分是获取主工程的资源文件，还是子工程的资源文件；
///   - bundle 参数获取 mainBundle 优先级高于通过 objClass 参数获取 mainBundle；
/// - `bundleName`：获取到 `mainBundle` 后，获取内部的 `xxx.bundle` 资源文件名称，主要取决于资源放的位置；
/// - `lproj`：语言文件
/// - 参考链接：https://www.jianshu.com/p/b64ff9d8e7ce、https://www.jianshu.com/p/173076faa742
public func JJC_Local(_ key: String, _ comment: String? = nil, bundle: Bundle? = nil, objClass: AnyClass? = nil, bundleFileName: String? = nil, lproj: String? = nil) -> String {
    return JJCLocal.jjc_local(key, comment, bundle: bundle, objClass: objClass, bundleFileName: bundleFileName, lproj: lproj)
}

// MARK: - 弹框提醒
/// JJCAPI - 弹框 Alert - title、message、leftTitle、leftStyle、rightTitle、rightStyle、leftAction、rightAction
public func JJC_Alert(title: String? = nil,
                      message: String,
                      leftTitle: String? = nil,
                      leftStyle: UIAlertAction.Style? = .cancel,
                      rightTitle: String? = nil,
                      rightStyle: UIAlertAction.Style? = .default,
                      leftAction: (() -> Void)? = nil,
                      rightAction: (() -> Void)? = nil,
                      lproj: String? = nil) -> UIAlertController {
    var newTitle: String? = nil
    if title == nil || (title ?? "").jjc_isEmptyOrInvalid() {
        newTitle = JJC_Local("Tips", "温馨提示", lproj: lproj)
    }
    let alertVC = UIAlertController(title: newTitle, message: message, preferredStyle: .alert)
    if var newLeftTitle = leftTitle {
        if newLeftTitle.jjc_isEmptyOrInvalid() {
            newLeftTitle = JJC_Local("Cancel", "取消", lproj: lproj)
        }
        let leftAction = UIAlertAction(title: newLeftTitle, style: leftStyle ?? .cancel) { _ in leftAction?() }
        alertVC.addAction(leftAction)
    }
    if var newRightTitle = rightTitle {
        if newRightTitle.jjc_isEmptyOrInvalid() {
            newRightTitle = JJC_Local("Confirm", "确定", lproj: lproj)
        }
        let rightAction = UIAlertAction(title: newRightTitle, style: rightStyle ?? .default) { _ in rightAction?() }
        alertVC.addAction(rightAction)
    }
    return alertVC
}

/// JJCAPI - HUD - 纯文本类型弹框
public func JJC_HUD_Message(_ content: String,
                            offset: CGPoint = .zero,
                            view: UIView? = nil,
                            completion: (() -> Void)? = nil) {
    let hud = JJCHUD.show(view ?? JJC_CurViewController().view)
    hud.setConfig(.message, content: content, offset: offset)
    hud.hideByDefault(completion)
}

/// JJCAPI - HUD - 成功失败弹框
public func JJC_HUD_SuccessOrFailure(_ content: String? = nil,
                                     isSuccess: Bool = true,
                                     lproj: String? = nil,
                                     offset: CGPoint = .zero,
                                     view: UIView? = nil,
                                     completion: (() -> Void)? = nil) {
    let hud = JJCHUD.show(view ?? JJC_CurViewController().view)
    hud.setConfig(isSuccess ? .success : .failure,
                  content: content ?? (isSuccess ? JJC_Local("Success", "成功", lproj: lproj) : JJC_Local("Failure", "失败", lproj: lproj)),
                  offset: offset)
    hud.hideByDefault(completion)
}

/// JJCAPI - HUD - 加载中、加载进度弹框
public func JJC_HUD_LoadingOrProgress(_ content: String? = nil,
                                      isLoading: Bool = true,
                                      lproj: String? = nil,
                                      offset: CGPoint = .zero,
                                      view: UIView? = nil) -> JJCHUD {
    let hud = JJCHUD.show(view ?? JJC_CurViewController().view)
    hud.setConfig(isLoading ? .loading : .progress,
                  content: content ?? "加载中...",
                  offset: offset)
    return hud
}

// MARK: - 圆角
/// JJCAPI - 圆角 - 继承 UIView - view、radius、width、color
public func JJC_RadiusBorder<T: UIView>(_ view: T, radius: CGFloat?, borderWidth: CGFloat?, borderColor: UIColor?) {
    if let newRadius = radius {
        view.layer.cornerRadius = newRadius
        view.layer.masksToBounds = true
    }
    if let newBorderWidth = borderWidth {
        view.layer.borderWidth = newBorderWidth
    }
    if let newBorderColor = borderColor {
        view.layer.borderColor = newBorderColor.cgColor
    }
}

/// JJCAPI - 圆角 - 继承 CALayer - layer、radius、width、color
public func JJC_RadiusBorder<T: CALayer>(_ layer: T, radius: CGFloat?, borderWidth: CGFloat?, borderColor: UIColor?) {
    if let newRadius = radius {
        layer.cornerRadius = newRadius
        layer.masksToBounds = true
    }
    if let newBorderWidth = borderWidth {
        layer.borderWidth = newBorderWidth
    }
    if let newBorderColor = borderColor {
        layer.borderColor = newBorderColor.cgColor
    }
}

/// JJCAPI - 通知 Name
public func JJC_Noti_Name(_ name: String) -> Notification.Name {
    return Notification.Name(rawValue: name)
}

/// JJCAPI - 发送通知
public func JJC_Noti_Post(_ name: String, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
    NotificationCenter.default.post(name: JJC_Noti_Name(name), object: object, userInfo: userInfo)
}

/// JJCAPI - 接收通知
public func JJC_Noti_AddObserver(_ name: String, observer: Any, selector: Selector, object: Any? = nil) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: JJC_Noti_Name(name), object: object)
}

/// JJCAPI - UUID
public func JJC_UUID() -> String {
    return Bundle.main.bundleIdentifier ?? "" + "_" + UUID().uuidString
}

/// JJCAPI - 系统信息 - 获取当前浅色、深色模式类型
public func JJC_CurThemeMode(isTheme: Bool = false) -> UIUserInterfaceStyle {
    if isTheme {
        return JJCTheme.shared.jjc_curTheme()
    } else {
        return UITraitCollection.current.userInterfaceStyle
    }
}

/// JJCAPI - 切换浅色、深色模式
public func JJC_ThemeMode(_ style: UIUserInterfaceStyle, isTheme: Bool = false) {
    if isTheme {
        JJCTheme.shared.jjc_switchTheme(style)
    } else {
        JJC_KeyWindow()?.overrideUserInterfaceStyle = style
    }
}

/// JJCAPI - 获取当前控制器视图 UIViewController
/// 参考链接：https://blog.51cto.com/928343994/5209078
public func JJC_CurViewController() -> UIViewController {
    var currentVC: UIViewController? = nil
    var keyWindow = JJC_KeyWindow()
    
    // 获取 KeyWindow（windowLevel 是在 Z轴方向上的窗口位置，默认值是 UIWindowLevel）
    if let tempWindow = keyWindow, tempWindow.windowLevel != .normal {
        // 获取应用程序的所有窗口并进行遍历，并找到程序的默认窗口（正在显示的窗口）
        for window in JJC_Windows() where window.windowLevel == UIWindow.Level.normal {
            keyWindow = window
            break
        }
    }
    
    // 根据获取到的 KeyWindow 获取当前根控制器，并判断是否存在
    if var rootVC = keyWindow?.rootViewController {
        // 如果是通过 present 的方式跳转（A.presentedViewController A控制器跳转到B控制器；B.presentingViewController 就是返回到A控制器）
        while let presentedVC = rootVC.presentedViewController {
            rootVC = presentedVC
        }
        // 匹配对应类型的控制器
        if rootVC.isKind(of: UITabBarController.self) {
            if let tabBarVC = rootVC as? UITabBarController,
               let lastVC = tabBarVC.viewControllers?[tabBarVC.selectedIndex].children.last {
                currentVC = lastVC
            }
        } else if rootVC.isKind(of: UINavigationController.self) {
            if let naviVC = rootVC as? UINavigationController,
                let lastVC = naviVC.children.last {
                currentVC = lastVC
            }
        } else if rootVC.isKind(of: UIViewController.self) {
            currentVC = rootVC
        }
    }
    return currentVC ?? UIViewController()
}

/// JJCAPI - 获取当前控制器对应的控制器链路层
/// 参考链接：https://blog.51cto.com/928343994/5209078
/// root：根控制器；present：跳转方式 present；push：跳转方式 push
/// tabBarVC：当前控制器是 UITabBarController；naviVC：当前控制器是 UINavigationController；vc：普通的 UIViewController
public func JJC_CurViewControllerLinkLayer() -> [[(vc: UIViewController, type: [String])]] {
    var curVC: UIViewController? = JJC_CurViewController()
    var allVCList = [[(vc: UIViewController, type: [String])]]()
    while curVC != nil, let tempCurVC = curVC {
        var vcList = [(vc: UIViewController, type: [String])]()
        if tempCurVC.isKind(of: UITabBarController.self) {
            vcList.append((tempCurVC, ["root", "tabbarVC"]))
        } else if tempCurVC.isKind(of: UINavigationController.self) {
            for (index, item) in tempCurVC.children.enumerated() {
                if index == 0 {
                    vcList.append((item, item.presentingViewController != nil ? ["present", "naviVC"]: ["root", "naviVC"]))
                } else {
                    vcList.append((item, ["push", "vc"]))
                }
            }
        } else {
            vcList.append((tempCurVC, tempCurVC.presentingViewController != nil ? ["present", "vc"] : ["root", "vc"]))
        }
        allVCList.insert(vcList, at: 0)
        curVC = tempCurVC.presentingViewController
        JJC_Log("打印 --- \(String(describing: vcList.description))")
    }
    return allVCList
}

/// JJCAPI - 延迟执行方法（通过 DispatchQueue）
public func JJC_AsyncAfter(_ delay: Double = 0, isToMain: Bool = true, completion: @escaping () -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
        if isToMain {
            DispatchQueue.main.async {
                completion()
            }
        } else {
            completion()
        }
    }
}
