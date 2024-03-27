//
//  Bundle+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/8/2.
//

import Foundation
import UIKit

// MARK: - Bundle - 获取资源文件
extension Bundle {
    /// Bundle - 获取主工程或子模块的主 Bundle
    ///
    /// 静态库 - 编译后获取的都是主工程的 Bundle
    /// 动态库 - 通过 bundleForClass 可以获取动态库对应的 Bundle，即子模块的 Bundle
    /// 参考链接：https://www.jianshu.com/p/b64ff9d8e7ce
    public static func jjc_mainBundle(_ isModule: Bool = false, objcClass: AnyClass? = nil) -> Bundle? {
        if isModule, let tempObjcClass = objcClass {
            return Bundle(for: tempObjcClass)
        } else {
            return Bundle.main
        }
    }
    
    /// Bundle - 根据 Bundle 名称获取对应的 Bundle 文件
    public static func jjc_bundle(bundle: String? = nil, isModule: Bool = false, objcClass: AnyClass? = nil) -> Bundle? {
        if let mainBundle = Bundle.jjc_mainBundle(isModule, objcClass: objcClass) {
            if let tempBundle = bundle,
                let path = mainBundle.path(forResource: tempBundle, ofType: "bundle") {
                return Bundle(path: path)
            } else {
                return mainBundle
            }
        }
        return nil
    }
    
    /// Bundle - 根据 Bundle 名称获取内部资源文件路径
    public static func jjc_bundle(file: String, ofType type: String, bundle: String? = nil, isModule: Bool = false, objcClass: AnyClass? = nil) -> String? {
        if let fileBundle = Bundle.jjc_bundle(bundle: bundle, isModule: isModule, objcClass: objcClass) {
            return fileBundle.path(forResource: file, ofType: type)
        }
        return nil
    }
    
    /// Bundle - 根据 Bundle 名称获取内部图片文件
    public static func jjc_bundle(image imageName: String, ofType type: String, bundle: String? = nil, isModule: Bool = false, objcClass: AnyClass? = nil) -> UIImage? {
        if let path = Bundle.jjc_bundle(file: imageName, ofType: type, bundle: bundle, isModule: isModule, objcClass: objcClass) {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
}

// MARK: - Bundle - JJCTools 内部使用
extension Bundle {
    /// Bundle - JJCTools - 获取主 Bundle
    public static func jjc_mainBundleByJJCTools() -> Bundle? {
        return Bundle(for: JJCGlobalClass.self)
    }
    
    /// Bundle - JJCTools - 根据 Bundle 名称获取对应的 Bundle 文件
    public static func jjc_bundleByJJCTools(bundle: String? = nil) -> Bundle? {
        if let mainBundle = Bundle.jjc_mainBundleByJJCTools(),
            let path = mainBundle.path(forResource: bundle, ofType: "bundle") {
            return Bundle(path: path)
        }
        return nil
    }
    
    /// Bundle - JJCTools - 根据 Bundle 名称获取内部资源文件路径
    public static func jjc_bundleByJJCTools(file: String, ofType type: String, bundle: String? = nil) -> String? {
        if let fileBundle = Bundle.jjc_bundleByJJCTools(bundle: bundle) {
            return fileBundle.path(forResource: file, ofType: type)
        }
        return nil
    }
    
    /// Bundle - JJCTools - 根据 Bundle 名称获取内部图片文件
    public static func jjc_bundleByJJCTools(image imageName: String, ofType type: String, bundle: String? = nil) -> UIImage? {
        if let path = Bundle.jjc_bundleByJJCTools(file: imageName, ofType: type, bundle: bundle) {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
}
