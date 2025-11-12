//
//  JJCLocal.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/9/22.
//

import UIKit
import Foundation

@MainActor
public class JJCLocal: NSObject {
    /// JJCLocal - 定义返回语言参数
    /// - localCode：当前语言编码
    /// - code：指定语言编码
    /// - showName：根据当前语言编码获取指定语言编码对应的语言名称
    /// - name：根据指定语言编码获取指定语言编码对应的语言名称
    /// - note：备注说明
    /**
     例如：
     1、当 App 内部设置为 zh-Hans 语言，则返回 [(zh-Hans, en, 英语, English), (zh-Hans, zh-Hans, 简体中文, 简体中文), (zh-Hans, zh-Hant, 繁体中文, 繁體中文), ...]；
     2、当 App 内部设置为 en 语言，则返回 [(en, en, English, English), (en, zh-Hans, Chinese Smiplified, 简体中文), (en, zh-Hant, Chinese Traditional, 繁體中文), ...]；
     */
    public typealias JJCLanguageParams = (localCode: String,
                                          code: String,
                                          showName: String?,
                                          name: String?,
                                          note: String?)
    
    /// JJCLocal - 定义返回系统语言参数
    /// - availableIdentifiers：系统所有本地化标识符数组列表
    /// - preferredLanguages：当前手机系统已添加全部语言【设置->通用->语言->首选语言顺序】，此处也可以通过 UserDefaults.standard.value(forKey: "AppleLanguages") 获取
    /// - systemLanguage：当前手机系统语言【设置->通用->语言->首选语言顺序】，此处也可以通过 UserDefaults.standard.value(forKey: "AppleLanguages") 获取
    public typealias JJCSystemLanguageParams = (availableIdentifiers: [String],
                                                preferredLanguages: [String],
                                                systemLanguage: String)
}

// MARK:- Language
extension JJCLocal {
    /// JJCLocal - 类方法
    public static func jjc_systemLanguageInfo() -> JJCSystemLanguageParams {
        return (Locale.availableIdentifiers,
                Locale.preferredLanguages,
                Locale.preferredLanguages.first ?? "en")
    }
    
    /// JJCLocal - 类方法 - 根据系统所有本地化标识符获取某语言显示对应语言名称（官方命名）
    /// - showId：以该种语言显示获取的结果
    /// - languageId：需要展示名称的语言
    /**
     例如：
     1、使用 zh-Hans 显示 en-CN 为 英语（中国大陆）；
     2、使用 en-CN 显示 zh-Hans 为 Chinese, Simplified；
     */
    public static func jjc_languageName(_ showId: String, _ languageId: String) -> String? {
        return Locale(identifier: showId).localizedString(forIdentifier: languageId)
    }
    
    /// JJCLocal - 类方法 - 根据系统本地化指定语言获取当前 App 内置所有语言环境
    /// - 返回参数：[(当前内置语言编码 code, 语言编码 code, 当前语言下该语言编码名称, 该语言编码语言环境下该语言编码名称)]
    public static func jjc_languages(_ bundle: Bundle = Bundle.main) -> [JJCLanguageParams] {
        let languages: [String] = bundle.localizations
        let curLanguage: String = JJCLocal.jjc_language(bundle)
        var tupleLanguages = [JJCLanguageParams]()
        for language in languages {
            let tuple: JJCLanguageParams = (curLanguage,
                                            language,
                                            Locale(identifier: curLanguage).localizedString(forIdentifier: language),
                                            Locale(identifier: language).localizedString(forIdentifier: language),
                                            nil)
            tupleLanguages.append(tuple)
        }
        return tupleLanguages
    }
    
    /// JJCLocal - 类方法 - 根据某一语言返回对应语言相关信息（同 jjc_languages 返回值）
    public static func jjc_language(_ bundle: Bundle = Bundle.main, lproj: String) -> JJCLanguageParams {
        let languages: [String] = bundle.localizations
        let curLanguage: String = JJCLocal.jjc_language(bundle)
        var tupleLanguage: JJCLanguageParams = (curLanguage,
                                                lproj,
                                                Locale(identifier: curLanguage).localizedString(forIdentifier: lproj),
                                                Locale(identifier: lproj).localizedString(forIdentifier: lproj),
                                                nil)
        for language in languages {
            if curLanguage == language {
                tupleLanguage = (curLanguage,
                                 lproj,
                                 Locale(identifier: curLanguage).localizedString(forIdentifier: lproj),
                                 Locale(identifier: lproj).localizedString(forIdentifier: lproj),
                                 nil)
                break
            }
        }
        return tupleLanguage
    }
    
    /// JJCLocal - 类方法 - 获取当前语言环境（根据 Bundle 获取 lproj 的语言文件）
    /// - 参考链接：https://www.jianshu.com/p/1199cda9c61b
    /// - `bundle` 和 `objClass`
    ///   - 是用于获取 `mainBundle（Bundle.main）` 的，主要是用于区分是获取主工程的资源文件，还是子工程的资源文件；
    ///   - bundle 参数获取 mainBundle 优先级高于通过 objClass 参数获取 mainBundle；
    public static func jjc_language(_ bundle: Bundle? = nil, objClass: AnyClass? = nil) -> String {
        // 0、获取 mainBundle
        var mainBundle = Bundle.main
        if let tempObjClass = objClass {
            mainBundle = Bundle(for: tempObjClass)
        }
        if let tempBundle = bundle {
            mainBundle = tempBundle
        }
        // 1、获取当前本地语言
        let language = mainBundle.preferredLocalizations.first ?? "en"
        var targetLanguage: String?
        // 2、获取当前 bundle 文件中所有本地语言
        let languages = mainBundle.localizations
        // 3.1、先查询是否有完全同名语言文件
        for string in languages {
            if language == string {
                targetLanguage = string
                break
            }
        }
        // 3.2、如果查询不到同名语言文件，则遍历查询获取第一个包含前缀的
        if targetLanguage == nil {
            for string in languages {
                if language.hasPrefix(string) {
                    targetLanguage = string
                    break
                }
            }
        }
        // 3.3、如果仍查询不到相同前缀的，则取当前语言首字符（国家缩写）进行匹配
        if targetLanguage == nil {
            if let languageHasPre = language.components(separatedBy: "-").first {
                for string in languages {
                    if string.hasPrefix(languageHasPre) {
                        targetLanguage = string
                        break
                    }
                }
            }
        }
        // 3.4、如果以上仍什么都查找不到，将其置为 en
        return targetLanguage ?? "en"
    }
    
    /// JJCLocal - 类方法 - 本地语言 - 带注释
    /// - `bundle` 和 `objClass`
    ///   - 是用于获取 `mainBundle（Bundle.main）` 的，主要是用于区分是获取主工程的资源文件，还是子工程的资源文件；
    ///   - bundle 参数获取 mainBundle 优先级高于通过 objClass 参数获取 mainBundle；
    /// - `bundleName`：获取到 `mainBundle` 后，获取内部的 `xxx.bundle` 资源文件名称，主要取决于资源放的位置；
    /// - `lproj`：语言文件
    /// - 参考链接：https://www.jianshu.com/p/b64ff9d8e7ce、https://www.jianshu.com/p/173076faa742
    public static func jjc_local(_ key: String, _ comment: String? = nil, bundle: Bundle? = nil, objClass: AnyClass? = nil, bundleFileName: String? = nil, lproj: String? = nil) -> String {
        var mainBundle = Bundle.main
        if let tempObjClass = objClass {
            mainBundle = Bundle(for: tempObjClass)
        }
        if let tempBundle = bundle {
            mainBundle = tempBundle
        }
        
        var mainLproj: String = JJCLocal.jjc_language(mainBundle)
        if let tempLproj: String = lproj {
            mainLproj = tempLproj
        }
        
        var result = key
        if let tempBundleFileName = bundleFileName,
            let bundleFilePath = mainBundle.path(forResource: tempBundleFileName, ofType: "bundle"),
            let bundleFile = Bundle(path: bundleFilePath) {
            // 获取 xxx.bundle 文件中的资源文件，暂时无法获取二级目录下的文件，image 用 contentsOfFile 获取
            if let lprojFilePath = bundleFile.path(forResource: mainLproj, ofType: "lproj"),
                let lprojFile = Bundle(path: lprojFilePath) {
                    result = lprojFile.localizedString(forKey: key, value: key, table: nil)
            }
        } else {
            if let lprojFile = Bundle(path: mainBundle.path(forResource: mainLproj, ofType: "lproj") ?? "") {
                result = lprojFile.localizedString(forKey: key, value: key, table: nil)
            } else {
                result = NSLocalizedString(key, bundle: mainBundle, comment: comment ?? key)
            }
        }
        return result
    }
    
    /// JJCLocal - 类方法 - 当前语言环境是否是中文
    /// - `bundle` 和 `objClass`
    ///   - 是用于获取 `mainBundle（Bundle.main）` 的，主要是用于区分是获取主工程的资源文件，还是子工程的资源文件；
    ///   - bundle 参数获取 mainBundle 优先级高于通过 objClass 参数获取 mainBundle；
    /// - 返回参数一：是否是中文；
    /// - 返回参数二：当前语言环境
    public static func jjc_isChinese(_ bundle: Bundle? = nil, objClass: AnyClass? = nil) -> (isChinese: Bool, language: String) {
        let preferredLang = JJCLocal.jjc_language(bundle, objClass: objClass)
        switch String(describing: preferredLang) {
        case "en-US", "en-CN":
            return (false, preferredLang)
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans","zh-Hant":
            return (true, preferredLang)
        default:
            return (false, preferredLang)
        }
    }
}
