//
//  JJCDevice.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/8/21.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import MediaPlayer

public class JJCDevice: NSObject {}

// MARK: - 获取系统属性
extension JJCDevice {
    /// JJCDevice - 获取设备号 ID【通过访问 IDFA 获取】
    public static func jjc_deviceID() -> String {
        var targetString = ""
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                if status == .authorized {
                    targetString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                }
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                targetString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        }
        return targetString
    }
    
    /// JJCDevice - 获取系统版本号
    public static func jjc_systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /// JJCDevice - 获取系统名称
    public static func jjc_systemName() -> String {
        return UIDevice.current.systemName
    }
    
    /// JJCDevice - 获取设备名称（自定义）
    public static func jjc_name() -> String {
        return UIDevice.current.name
    }
    
    /// JJCDevice - 获取当前设备方向
    public static func jjc_interfaceOrientation() -> UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    /// JJCDevice - 判断当前设备是否横屏
    public static func jjc_isLandScape() -> Bool {
        return UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
}

// MARK: - 获取设备类型
extension JJCDevice {
    /// JJCDevice - 判断是否是某一设备
    public static func jjc_device(_ type: UIUserInterfaceIdiom) -> Bool {
        return UIDevice.current.userInterfaceIdiom == type
    }
    
    /// JJCDevice - 判断是否为 iPhone
    public static func jjc_isIPone() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .phone)
    }
    
    /// JJCDevice - 判断是否为 iPad
    public static func jjc_isIPad() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .pad)
    }
    
    /// JJCDevice - 判断是否为 CarPlay
    public static func jjc_isCarPlay() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .carPlay)
    }
    
    /// JJCDevice - 判断是否为 mac
    public static func jjc_isMac() -> Bool {
        if #available(iOS 14.0, *) {
            return (UIDevice.current.userInterfaceIdiom == .mac)
        } else {
            return false
        }
    }
    
    /// JJCDevice - 判断是否为 tv
    public static func jjc_isTV() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .tv)
    }
    
    /// 是否是刘海屏
    public static func jjc_isIPhoneX() -> Bool {
        return JJC_IsIPhoneX()
    }
}

// MARK: - 获取、更改设备信息
extension JJCDevice {
    /// JJCDevice - 获取系统音量（参考链接：https://juejin.cn/post/7049606971032338439）
    public static func jjc_systemVolume() -> CGFloat {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {}
        return CGFloat(AVAudioSession.sharedInstance().outputVolume)
    }
    
    /// JJCDevice - 调节系统音量（参考链接：https://juejin.cn/post/7049606971032338439）
    public static func jjc_updateSystemVolume(_ value: CGFloat) {
        let volumeV = MPVolumeView()
        if let childV = volumeV.subviews.first as? UISlider {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                childV.value = Float(value)
            }
        }
    }
}
