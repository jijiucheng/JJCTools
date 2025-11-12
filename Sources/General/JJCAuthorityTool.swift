//
//  JJCAuthorityTool.swift
//  JJCTools
//
//  Created by mxgx on 2024/6/9.
//

@preconcurrency import UIKit
import AdSupport
import AppTrackingTransparency

public class JJCAuthorityTool: NSObject {}

extension JJCAuthorityTool {
    /// SystemTool - 校验通知权限状态
    public static func checkNotificationAuthorizationStatus(isRequest: Bool = false, completion: ((_ isRequest: Bool, _ status: UNAuthorizationStatus?, _ requestResult: (granted: Bool, error: (any Error)?)?) -> Void)? = nil) {
        // 获取当前通知权限状态
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            JJC_Log("[日志] 通知权限 - 当前通知权限状态 --- \(settings.authorizationStatus)")
            if settings.authorizationStatus == .notDetermined && isRequest {
                // 请求权限
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    JJC_Log("[日志] 通知权限 - 请求通知权限结果 --- granted = \(granted), error = \(String(describing: error))")
                    completion?(isRequest, settings.authorizationStatus, (granted, error))
                }
            } else {
                completion?(isRequest, settings.authorizationStatus, nil)
            }
        }
    }
    
    /// SystemTool - 隐私追踪权限
    public static func checkTrackingAuthorizationStatus(isRequest: Bool = false, completion: ((_ isRequest: Bool, _ isAuthority: Bool, _ advertisingId: String) -> Void)? = nil) {
        // 获取 IDFA（如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值）
        var isAuthority = false
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            switch status {
            case .notDetermined: JJC_Log("[日志] 隐私追踪权限 - 当前隐私追踪权限状态 - 用户未做选择或未弹框")
            case .denied: JJC_Log("[日志] 隐私追踪权限 - 当前隐私追踪权限状态 - 用户拒绝 IDFA 追踪权限")
            case .authorized:
                JJC_Log("[日志] 隐私追踪权限 - 当前隐私追踪权限状态 - 用户允许 IDFA 追踪权限")
                isAuthority = true
            default: break
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                JJC_Log("[日志] 隐私追踪权限 - 当前隐私追踪权限状态 - 用户允许 IDFA 追踪权限")
                isAuthority = true
            } else {
                JJC_Log("[日志] 隐私追踪权限 - 当前隐私追踪权限状态 - 用户拒绝 IDFA 追踪权限")
            }
        }
        
        // 申请 IDFA 权限
        var advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if #available(iOS 14, *), !isAuthority && isRequest {
            ATTrackingManager.requestTrackingAuthorization { status in
                JJC_Log("[日志] 隐私追踪权限 - 请求隐私追踪权限结果 - \(status.rawValue)")
                if status == .authorized {
                    isAuthority = true
                    advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                }
                JJC_Log("[日志] 获取用户 IDFA 结果 - AdvertisingId - \(advertisingId)")
                completion?(isRequest, isAuthority, advertisingId)
            }
        } else {
            JJC_Log("[日志] 获取用户 IDFA 结果 - AdvertisingId - \(advertisingId)")
            completion?(isRequest, isAuthority, advertisingId)
        }
    }
}
