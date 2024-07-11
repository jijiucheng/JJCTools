//
//  JJCApp.swift
//  JJCTools
//
//  Created by mxgx on 2023/6/19.
//

import UIKit
import Foundation

public class JJCApp: NSObject {}

// MARK: - 获取 App 相关信息
extension JJCApp {
    /// JJCApp - 获取 App 的唯一识别号 BundleIdentifier【CFBundleIdentifier】
    public static func jjc_bundleId() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
    }
    
    /// JJCApp - 获取 App 名称【DisplayName】
    public static func jjc_displayName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
    /// JJCApp - 获取 App 名称【CFBundleName】
    public static func jjc_bundleName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    }
    
    /// JJCApp - 获取 App release 版本号【CFBundleShortVersionString】
    public static func jjc_releaseVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// JJCApp - 获取 App debug 版本号【CFBundleVersion】
    public static func jjc_debugVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    /// JJCApp - 获取 App 版本号（releaseVersion + debugVersion）【CFBundleShortVersionString + CFBundleVersion】
    public static func jjc_fullVersion() -> String {
        return "\(JJCApp.jjc_releaseVersion())(\(JJCApp.jjc_debugVersion()))"
    }
    
    /// JJCApp - 获取 App 版本号信息
    public static func jjc_version() -> (release: String, debug: String, full: String) {
        return (JJCApp.jjc_releaseVersion(),
                JJCApp.jjc_debugVersion(),
                JJCApp.jjc_fullVersion())
    }
}

// MARK: - 常见权限检测
extension JJCApp {
    /// JJCApp - 检查是否开启通知权限
    public static func jjc_checkPermission_notification(completion: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings { (setting) in
            completion(setting.notificationCenterSetting == .enabled)
        }
    }
}

// MARK: - 常见的跳转
extension JJCApp {
    /// JJCApp - 跳转 App 设置界面
    public static func jjc_open_appSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
