//
//  JJCICloudTool.swift
//  JJCTools
//
//  Created by mxgx on 2024/6/9.
//

/*
 iCloud 使用
 
 1、首先创建一个继承自 UIDocument 的子类；
 2、通过 FileManager.default.ubiquityIdentityToken 和 FileManager.default.url(forUbiquityContainerIdentifier: nil) 分别检测是否登录 iCloud 和 iCloud 服务是否可用；
 3、重写 func contents(forType typeName: String) throws -> Any 和 func load(fromContents contents: Any, ofType typeName: String?) throws 方法，让文档根据 App 内部的机制来实现保存和读取；
 4、func contents(forType typeName: String) throws -> Any 方法只允许返回 NSData 或者 NSFileWrapper 类型，否则会报错，但是可以通过重写 writeContents:andAttributes:safelyToURL:forSaveOperation:error: 方法来解决这个问题；
 5、通过 UIDocument 的 saveToURL:forSaveOperation:completionHandler: 将文档保存到 iCloud 容器中；
 6、通过 NSMetadataQuery 来获取 iCloud 容器的文档列表，并更新到本地。
 
 
 参考链接：
 
 简书 - 杰嗒嗒的阿杰 - iCloud开发实践 [https://www.jianshu.com/p/33ebab1c2ee1]
 简书 - 杰嗒嗒的阿杰 - 【iOS扩展开发攻略】Action Extension [https://www.jianshu.com/p/37f23426bb04]
 简书 - iOS_肖晨 - iOS NSData与其他类型互转 [https://www.jianshu.com/p/878a1a998f15]
 简书 - 流火绯瞳 - [iOS]文档操作之UIDocument [https://www.jianshu.com/p/857f5f917dab]
 Github - Daryl's Blog - UIDocument的使用 [http://daryl5.github.io/blog/2014/04/01/how-to-use-uidocument/]
 */

import UIKit

public enum JJCICloudResultType: Int {
    case unavailable = 0        // 不可用
    case backupSuccess          // 备份成功
    case backupFailure          // 备份失败
    case recoverySuccess        // 恢复成功
    case recoveryFailure        // 恢复失败
}

@MainActor
public class JJCICloudTool: UIDocument {
    /// JJCICloudTool - 查询实例
    fileprivate lazy var metadataQuery: NSMetadataQuery = {
        let metadata = NSMetadataQuery()
        metadata.searchScopes = [NSMetadataQueryUbiquitousDataScope]
        metadata.predicate = NSPredicate(value: true)
        return metadata
    }()
    
    public override init(fileURL url: URL) {
        super.init(fileURL: url)
    }
}

// MARK: - 基础方法
extension JJCICloudTool {
    /// JJCICloudTool - 获取 iCloud 容器地址
    public static func getICloudDocumentUrl(_ containerId: String? = nil, path: String = "Documents") -> URL? {
        // 检测是否登录 iCloud 账户，如果为 nil，则未登录
        guard FileManager.default.ubiquityIdentityToken != nil else { return nil }
        /**
         forUbiquityContainerIdentifier
             参数传入 nil，默认返回容器数组中的第一个容器；也可以传入配置时的容器名称
            （如：iCloud.com.jijiucheng.JJCListeningBook）

         如果返回 nil，则表示 iCloud 服务不可用
        */
        if let url = FileManager.default.url(forUbiquityContainerIdentifier: containerId) {
            if #available(iOS 16.0, *) {
                return url.appending(path: path)
            } else {
                return url.appendingPathComponent(path)
            }
        }
        return nil
    }
    
    /// JJCICloudTool - 创建查询对象
    public static func createICloudTool(_ containerId: String? = nil, path: String = "Documents") -> (url: URL, iCloudTool: JJCICloudTool)? {
        if let url = JJCICloudTool.getICloudDocumentUrl(containerId, path: path) {
            return (url, JJCICloudTool(fileURL: url))
        } else {
            return nil
        }
    }
}

// MARK: - 备份数据、恢复数据
extension JJCICloudTool {
    /// JJCICloudTool - 备份数据、恢复数据
    public func handleICloudData(_ containerId: String? = nil, path: String = "Documents", isBackup: Bool, completion: (() -> Void)? = nil) {
        if let res = JJCICloudTool.createICloudTool(containerId, path: path) {
            JJC_Log("[日志] iCloud - 当前 iCloud 路径：\(res.url.absoluteString))")
            if isBackup {
                // 备份数据
                res.iCloudTool.save(to: res.url, for: .forOverwriting) { isSuccess in
                    JJC_Log("[日志] iCloud - 备份\(isSuccess ? "成功" : "失败")")
                }
            } else {
                // 恢复数据
                NotificationCenter.default.addObserver(self, selector: #selector(queryFinished), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(queryFinished), name: NSNotification.Name.NSMetadataQueryDidUpdate, object: nil)
                metadataQuery.start()
            }
        } else {
            JJC_Log("[日志] iCloud - 当前 iCloud 服务不可用")
        }
    }
    
    // 查询完成
    @objc fileprivate func queryFinished() {
        JJC_Log("[日志] iCloud - 有查询结果")
        if let res = JJCICloudTool.createICloudTool() {
            res.iCloudTool.open { isSuccess in
                JJC_Log("[日志] iCloud - 恢复\(isSuccess ? "成功" : "失败")")
            }
            
            metadataQuery.enumerateResults { result, index, stop in
                JJC_Log("[日志] iCloud - 查询结果 - \(stop) - \(index) - \(result)")
            }
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSMetadataQueryDidUpdate, object: nil)
        
        metadataQuery.stop()
    }
    
    /*
    contentsForType:error:方法只允许返回NSData或者NSFileWrapper类型，不能直接把UIImage类型进行返回，否则会抛出错误提示
    可以重写writeContents:andAttributes:safelyToURL:forSaveOperation:error:方法来解决这个问题
    */
    public override func contents(forType typeName: String) throws -> Any {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: ["测试备份数据"] as Any, options: .prettyPrinted)
            return data
        } catch _ {
            let data: Data = try JSONSerialization.data(withJSONObject: [""] as Any, options: .prettyPrinted)
            return data
        }
    }
    
    public override func load(fromContents contents: Any, ofType typeName: String?) throws {
        do {
            let array = try JSONSerialization.jsonObject(with: contents as! Data, options: .allowFragments) as! [String]
            JJC_Log("[日志] iCloud - 恢复结果 1 --- \(array)")
        } catch let error {
            JJC_Log("[日志] iCloud - 恢复结果 2 --- \(error)")
        }
    }
}
