//
//  Bundle+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/8/2.
//

import Foundation
import UIKit

//MARK: - Bundle - 获取资源文件
extension Bundle {
    /// Bundle - 根据 bundle 名称获取对应 Bundle
    public static func jjc_bundle(_ bundle: String) -> Bundle? {
        return Bundle(path: Bundle.main.path(forResource: bundle, ofType: "bundle") ?? "")
    }
    
    /// Bundle - 根据 bundle 名称获取对应内部资源文件路径
    public static func jjc_bundleFile(resource: String, ofType type: String, bundle: String) -> String? {
        return Bundle.jjc_bundle(bundle)?.path(forResource: resource, ofType: type)
    }
    
    /// Bundle - 根据 bundle 名称获取对应内部图片文件路径
    public static func jjc_bundleImage(resource: String, ofType type: String, bundle: String) -> UIImage? {
        return UIImage(contentsOfFile: Bundle.jjc_bundle(bundle)?.path(forResource: resource, ofType: type) ?? "")
    }
}
