//
//  JJCAppInfo.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/8/21.
//

import UIKit

public class JJCAppInfo: NSObject {}

// MARK: - 获取 App 相关信息
extension JJCAppInfo {
    /// JJCAppInfo - 获取 App 的唯一识别号 BundleIdentifier【CFBundleIdentifier】
    public static func jjc_bundleIdentifier() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
    }
    
    /// JJCAppInfo - 获取 App 名称【DisplayName】
    public static func jjc_displayName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
    /// JJCAppInfo - 获取 App 名称【CFBundleName】
    public static func jjc_bundleName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    }
    
    /// JJCAppInfo - 获取 App release 版本号【CFBundleShortVersionString】
    public static func jjc_releaseVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// JJCAppInfo - 获取 App debug 版本号【CFBundleVersion】
    public static func jjc_debugVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    /// JJCAppInfo - 获取 App 版本号（releaseVersion + debugVersion）【CFBundleShortVersionString + CFBundleVersion】
    public static func jjc_fullVersion() -> String {
        return "\(JJCAppInfo.jjc_releaseVersion())(\(JJCAppInfo.jjc_debugVersion()))"
    }
    
    /// JJCAppInfo - 获取 App 版本号信息
    public static func jjc_version() -> (release: String, debug: String, full: String) {
        return (JJCAppInfo.jjc_releaseVersion(),
                JJCAppInfo.jjc_debugVersion(),
                JJCAppInfo.jjc_fullVersion())
    }
}

