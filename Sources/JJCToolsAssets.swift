//
//  JJCToolsAssets.swift
//  JJCTools
//
//  Created by mxgx on 2024/7/11.
//

/*
 JJCToolsAssets - 获取 framework 中的资源文件
 */

import UIKit

class JJCToolsAssets: NSObject {
    /// JJCToolsAssets - 获取 framework 中的图片资源文件
    static func jjc_bundleImage(_ name: String) -> UIImage? {
        let bundle = Bundle(for: JJCToolsAssets.self)
        if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
            return image
        } else if let url = bundle.url(forResource: "JJCTools", withExtension: "bundle"),
                  let image = UIImage(named: name, in: Bundle(url: url), compatibleWith: nil) {
            return image
        }
        return nil
    }
    
    /// JJCToolsAssets - 获取 framework 中的图片资源文件
    static func jjc_bundleColor(_ name: String) -> UIColor? {
        let bundle = Bundle(for: JJCToolsAssets.self)
        if let color = UIColor(named: name, in: bundle, compatibleWith: nil) {
            return color
        } else if let url = bundle.url(forResource: "JJCTools", withExtension: "bundle"),
                  let color = UIColor(named: name, in: Bundle(url: url), compatibleWith: nil) {
            return color
        }
        return nil
    }
}
