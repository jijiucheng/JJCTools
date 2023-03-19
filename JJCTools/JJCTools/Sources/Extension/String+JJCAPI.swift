//
//  String+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/7/28.
//

import Foundation
import UIKit

//MARK: - String 字符串判断是否为空、有效
extension String {
    /// String - 字符串判断 - 判断字符串是否为空或无效（目标字符串可为 Optional 类型）
    public static func jjc_isEmptyOrInvalid(_ string: String?) -> Bool {
        guard let tempString = string else {
            return true
        }
        // 过滤特殊字符
        let content = tempString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty && content.count != 0 else {
            return true
        }
        // 判断是否是特殊空字符串
        let contentArray = ["null", "<null>", "(null)", "NULL", "<NULL>", "(NULL)"]
        for string in contentArray where content == string {
            return true
        }
        return false
    }
    
    /// String - 字符串判断 - 判断字符串是否不为空或有效（目标字符串可为 Optional 类型）
    public static func jjc_isNotEmptyOrValid(_ string: String?) -> Bool {
        return !String.jjc_isEmptyOrInvalid(string)
    }
    
    /// String - 字符串判断 - 判断字符串是否为空或无效
    public func jjc_isEmptyOrInvalid() -> Bool {
        return String.jjc_isEmptyOrInvalid(self)
    }
    
    /// String - 字符串判断 - 判断字符串是否不为空或有效
    public func jjc_isNotEmptyOrValid() -> Bool {
        return !String.jjc_isEmptyOrInvalid(self)
    }
    
    /// String - 字符串判断 - 判断字符串是否是合法的 url（目标字符串可为 Optional 类型）
    public static func jjc_isVaildUrl(_ string: String?) -> Bool {
        guard String.jjc_isNotEmptyOrValid(string) else {
            return false
        }
        guard let tempString = string, tempString.hasPrefix("http") else {
            return false
        }
        return true
    }
    
    /// String - 字符串判断 - 判断字符串是否是合法的 url
    public func jjc_isVaildUrl() -> Bool {
        return String.jjc_isVaildUrl(self)
    }
    
    /// String - 字符串判断 - 判断字符串是否包含中文
    public func jjc_isContainsChinese() -> Bool {
        for char in self where char >= "\u{4E00}" && char <= "\u{9FA5}" {
            return true
        }
        return false
    }
}

//MARK: - String 字符串截取、替换、移除
extension String {
    /// String - 字符串截取 - start、end
    public func jjc_subRange(byStart start: Int, _ end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex   = self.index(self.startIndex, offsetBy: ((end + 1) > self.count ? self.count : (end + 1)))
        return String(self[startIndex...endIndex])
    }
    
    /// String - 字符串截取 - location、length
    public func jjc_subRange(byLocation location: Int, _ length: Int) -> String {
        return jjc_subRange(byStart: location, (location + length))
    }
    
    /// String - 字符串截取 - Range
    public func jjc_subRange(byRange range: Range<String.Index>) -> String {
        return jjc_subRange(byStart: range.lowerBound.hashValue, range.upperBound.hashValue)
    }
    
    /// String - 字符串截取 - NSRange
    public func jjc_subRange(byNSRange range: NSRange) -> String {
        return jjc_subRange(byStart: range.location, (range.location + range.length))
    }
    
    /// String - 字符串替换 - Range、replaceString
    public func jjc_replace(byRange range: Range<String.Index>, with replace: String) -> String {
        var targetString = self
        targetString.replaceSubrange(range, with: replace)
        return targetString
    }
    
    /// String - 字符串替换 - start、end、replaceString
    public func jjc_replace(byStart start: Int, _ end: Int, with replace: String) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex   = self.index(self.startIndex, offsetBy: ((end + 1) > self.count ? self.count : (end + 1)))
        var targetString = self
        targetString.replaceSubrange(startIndex..<endIndex, with: replace)
        return targetString
    }
    
    /// String - 字符串替换 - location、length、replaceString
    public func jjc_replace(byLocation location: Int, _ length: Int, with replace: String) -> String {
        return jjc_replace(byStart: location, (location + length), with: replace)
    }
    
    /// String - 字符串替换 - NSRange、replaceString
    public func jjc_replace(byNSRange range: NSRange, with replace: String) -> String {
        return jjc_replace(byStart: range.location, (range.location + range.length), with: replace)
    }
    
    /// String - 字符串替换 - 批量替换（多种字符替换成多种，一对一替换）[String] -> [String]
    public func jjc_replace(byCharacters characters: [String], replaces: [String]) -> String {
        guard characters.count == replaces.count else {
            return self
        }
        var targetString = self
        for index in 0..<characters.count {
            targetString = targetString.replacingOccurrences(of: characters[index], with: replaces[index])
        }
        return targetString
    }
    
    /// String - 字符串替换 - 批量替换（多种字符替换成一种）[String] -> String
    public func jjc_replace(byCharacters characters: [String], replace: String) -> String {
        var targetString = self
        characters.forEach({ targetString = targetString.replacingOccurrences(of: $0, with: replace) })
        return targetString
    }
    
    /// String - 字符串移除 - 移除字符数组
    public func jjc_remove(byCharacters characters: [String]) -> String {
        return jjc_replace(byCharacters: characters, replace: "")
    }
    
    /// String - 字符串移除 - 移除转移符
    /**
     \a - Sound alert       \b - 退格         \f - Form feed
     \n - 换行               \r - 回车         \t - 水平制表符
     \v - 垂直制表符          \\ - 反斜杠       \" - 双引号
     \' - 单引号             \0 - 空字符
     */
    public func jjc_removeByEscapeCharacter() -> String {
        let escapeArray = ["\\a", "\\b", "\\f", "\\n", "\\r", "\\t", "\\v", "\\", "\"", "\'", "\0"]
        return jjc_remove(byCharacters: escapeArray)
    }
}

//MARK: - String 字符串转换
extension String {
    /// String - 字符串转换 - 根据正则获取字符串中匹配的字符串
    /**
     参考链接：菜鸟工具 - https://c.runoob.com/front-end/854
     
     . - 除换行符以外的所有字符。
     ^ - 字符串开头。
     $ - 字符串结尾。
     \d,\w,\s - 匹配数字、字符、空格。
     \D,\W,\S - 匹配非数字、非字符、非空格。
     [abc] - 匹配 a、b 或 c 中的一个字母。
     [a-z] - 匹配 a 到 z 中的一个字母。
     [^abc] - 匹配除了 a、b 或 c 中的其他字母。
     aa|bb - 匹配 aa 或 bb。
     ? - 0 次或 1 次匹配。
     * - 匹配 0 次或多次。
     + - 匹配 1 次或多次。
     {n} - 匹配 n次。
     {n,} - 匹配 n次以上。
     {m,n} - 最少 m 次，最多 n 次匹配。
     (expr) - 捕获 expr 子模式,以 \1 使用它。
     (?:expr) - 忽略捕获的子模式。
     (?=expr) - 正向预查模式 expr。
     (?!expr) - 负向预查模式 expr。
     
     typedef NS_OPTIONS(NSUInteger, NSRegularExpressionOptions) {
        NSRegularExpressionCaseInsensitive             = 1 << 0, //不区分字母大小写的模式
        NSRegularExpressionAllowCommentsAndWhitespace  = 1 << 1, //忽略掉正则表达式中的空格和#号之后的字符
        NSRegularExpressionIgnoreMetacharacters        = 1 << 2, //将正则表达式整体作为字符串处理
        NSRegularExpressionDotMatchesLineSeparators    = 1 << 3, //允许.匹配任何字符，包括换行符
        NSRegularExpressionAnchorsMatchLines           = 1 << 4, //允许^和$符号匹配行的开头和结尾
        NSRegularExpressionUseUnixLineSeparators       = 1 << 5, //设置\n为唯一的行分隔符，否则所有的都有效。
        NSRegularExpressionUseUnicodeWordBoundaries    = 1 << 6  //使用Unicode TR#29标准作为词的边界，否则所有传统正则表达式的词边界都有效
     };
     */
    public func jjc_getRegexStrings(_ pattern: String) -> [String] {
        var array = [String]()
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators])
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            results.forEach({ array.append((self as NSString).substring(with: $0.range)) })
        } catch let error {
            JJC_Log("[Error] 根据正则获取字符串中匹配的字符串失败 - \(error)")
        }
        return array
    }
    
    /// String - 字符串转换 - 中文转拼音（isTone：是否带声调，isDealü：是否处理特殊拼音 ü）
    public func jjc_toPinYin(isTone: Bool? = nil, isDealü: Bool? = nil) -> String {
        var mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        // 特殊处理 ǖ、ǘ、ǚ、ǜ、ü -> v
        if let tempIsDealü = isDealü, tempIsDealü {
            mutableString = NSMutableString(string: String(mutableString).jjc_replace(byCharacters: ["ǖ", "ǘ", "ǚ", "ǜ", "ü"], replace: "v"))
        }
        if let tempIsTone = isTone, !tempIsTone {
            CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        }
        return String(mutableString).jjc_replace(byCharacters: [" "], replace: "")
    }
}

//MARK: - String 字符串 URL 处理
extension String {
    /// String - URL - 拼接路径
    public func jjc_appendURLPath(_ path: String) -> String {
        let targetString = self
        return targetString + (targetString.hasSuffix("/") ? "" : "/") + path
    }
    
    /// String - URL - 获取 url 路径下最后一个参数（如：https://m.baidu.com/chapter/12345/tag/index.html 获取的就是 index.html）
    public func jjc_getURLLastParam() -> String {
        var targetString = self
        let params = targetString.components(separatedBy: "/")
        if params.count > 0 {
            let diffNum = params.count > 1 && targetString.hasSuffix("/") ? 2 : 1
            targetString = params[params.count - diffNum]
        }
        return targetString
    }
    
    /// String - URL - 移除 url 路径下最后一个参数（如：https://m.baidu.com/chapter/12345/tag/index.html 移除的就是 index.html）
    public func jjc_removeURLLastParam() -> String {
        var targetString = self
        let params = targetString.components(separatedBy: "/")
        if params.count > 0 {
            let diffNum = params.count > 1 && targetString.hasSuffix("/") ? 2 : 1
            targetString = ""
            for (index, value) in params.enumerated() where index < params.count - diffNum {
                targetString = targetString + value + "/"
            }
        }
        return targetString
    }
}

//MARK: - String 字符串编码解码
extension String {
    /// String - 获取编码类型
    public static func jjc_getEncodingType(_ encodingType: CFStringEncodings) -> String.Encoding {
        return String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(encodingType.rawValue)))
    }
    
    /// String - 根据编码类型转编码
    /// - 参考链接：https://shino.space/2017/swift%E4%B8%ADUTF8%E4%B8%8EGBK%E7%9A%84%E8%BD%AC%E6%8D%A2/
    public func jjc_toEncodingString(_ encodingType: CFStringEncodings) -> String {
        let enc = String.jjc_getEncodingType(encodingType)
        var targetString = ""
        if let gbkData = (self as NSString).data(using: enc.rawValue) {
            let gbkBytes = [UInt8](gbkData)
            for gbk in gbkBytes {
                targetString.append(NSString(format: "%%%X", gbk) as String)
            }
        }
        return targetString
    }
    
    /// String - 根据 Data 和编码类型 转编码
    public static func jjc_toEncodingString(data: Data, encodingType: CFStringEncodings) -> String {
        let enc = String.jjc_getEncodingType(encodingType)
        var targetString = ""
        if let dataString = String(data: data, encoding: enc) {
            targetString = dataString
        }
        return targetString
    }
    
    /******************** GBK_2312 *****************/
    
    /// String - 获取 GBK_2312 编码类型
    public static func jjc_getEncodingTypeGBK2312() -> String.Encoding {
        return String.jjc_getEncodingType(.GB_18030_2000)
    }
    
    /// String - 转 GBK_2312 编码
    /// - 参考链接：https://shino.space/2017/swift%E4%B8%ADUTF8%E4%B8%8EGBK%E7%9A%84%E8%BD%AC%E6%8D%A2/
    public func jjc_toEncodingStringWithGBK2312S() -> String {
        return jjc_toEncodingString(.GB_18030_2000)
    }
    
    /// String - Data 转 GBK_2312 编码 HtmlString
    public static func jjc_toEncodingStringWithGBK2312S(_ data: Data) -> String {
        let enc = String.jjc_getEncodingType(.GB_18030_2000)
        var targetString = ""
        if let dataString = String(data: data, encoding: enc) {
            /*
             需要将 这句 转换成 UTF-8 编码，否则会报 encoding error : input conversion failed due to input error, bytes 0x89 0x91 0xE9 0xA3
             参考链接：https://blog.csdn.net/toolazytoname/article/details/10051681
             参考链接：https://www.jianshu.com/p/27b9c947719e
             <meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\" />
             <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
             */
            targetString = dataString
            let utf8String = "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\" />"
            if dataString.contains(utf8String) {
                let newUtf8String = utf8String.jjc_toUTF8String()
                if !newUtf8String.isEmpty {
                    targetString = targetString.replacingOccurrences(of: utf8String, with: newUtf8String)
                }
            }
        }
        return targetString
    }
    
    /******************** GBK_2312 *****************/
    
    /// String - Base64 编码、解码
    /// - reverse：是否反向：
    ///   - true  - 编码；
    ///   - false - 解码。
    public func jjc_toBase64String(_ reverse: Bool = true) -> String {
        var targetString = ""
        if reverse {
            if let encodeData = self.data(using: .utf8) {
                targetString = encodeData.base64EncodedString(options: [])
            }
        } else {
            if let decodeData = Data(base64Encoded: self, options: []) {
                if let decodeString = String(data: decodeData, encoding: .utf8) {
                    targetString = decodeString
                }
            }
        }
        return targetString
    }
    
    /// String - Unicode 编码、解码
    /// - reverse：是否反向：
    ///   - true  - 编码；
    ///   - false - 解码。
    /// - 参考链接：https://www.jianshu.com/p/ea99580ea30f
    /// - 参考链接：https://www.jianshu.com/p/80903324fa19#comments
    /// - 参考链接：https://stackoverflow.com/questions/24318171/using-swift-to-unescape-unicode-characters-ie-u1234
    /// - 参考链接：https://blog.csdn.net/blueone009/article/details/50437145
    /**
     另外一种实现方案：
     func unicodeString(_ str: String) -> String {
         let mutableStr = NSMutableString(string: str) as CFMutableString
         CFStringTransform(mutableStr, nil, "Any-Hex/Java" as CFString, true)
         return mutableStr as String
     }
     */
    public func jjc_toUnicodeString(_ reverse: Bool = true) -> String {
        var targetString = self.replacingOccurrences(of: "\\U", with: "\\u")
        targetString = targetString.applyingTransform(StringTransform(rawValue: "Any-Hex/Java"), reverse: !reverse) ?? ""
        return targetString
    }
    
    /// String - 字符串 和 UTF-8 互转
    /// - reverse：是否反向：
    ///   - true  - 字符串 转 UTF-8（String -> UTF-8 String）；
    ///   - false - UTF-8 转 字符串（UTF-8 String -> String）。

    /// String - 字符串 转 UTF-8（String -> UTF-8 String）
    public func jjc_toUTF8String(_ reverse: Bool = true) -> String {
        if reverse {
            return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        } else {
            return self.removingPercentEncoding ?? ""
        }
    }
}

//MARK: - String - 获取字符串宽高
extension String {
    /// String - 获取字符串尺寸（CGSize）
    public static func jjc_getContentSize(_ content: String,
                                          font: UIFont? = nil,
                                          fontFamily: String? = nil,
                                          fontSize: CGFloat? = nil,
                                          weight: UIFont.Weight? = nil,
                                          size: CGSize,
                                          options: NSStringDrawingOptions? = nil,
                                          paragraphStyle: NSParagraphStyle? = nil) -> CGSize {
        var tempFont: UIFont?
        if let newFont = font {
            tempFont = newFont
        }
        if let newFontSize = fontSize {
            if let newFontFamily = fontFamily {
                tempFont = UIFont(name: newFontFamily, size: newFontSize)
            } else {
                tempFont = .systemFont(ofSize: newFontSize, weight: weight ?? .regular)
            }
        }

        var attributes: [NSAttributedString.Key : Any]?
        if let newParagraphStyle = paragraphStyle {
            attributes = [NSAttributedString.Key.font: tempFont as Any,
                          NSAttributedString.Key.paragraphStyle: newParagraphStyle]
        } else {
            attributes = [NSAttributedString.Key.font: tempFont as Any]
        }

        let option = NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue
        let contentSize = NSString(string: content).boundingRect(with: size,
                                                                 options: options ?? NSStringDrawingOptions(rawValue: option),
                                                                 attributes: attributes,
                                                                 context: nil).size
        return contentSize
    }
    
    /// String - 获取字符串尺寸
    public static func jjc_getContentSize(_ content: String,
                                          font: UIFont? = nil,
                                          fontFamily: String? = nil,
                                          fontSize: CGFloat? = nil,
                                          weight: UIFont.Weight? = nil,
                                          contentMaxWH: CGFloat? = nil,
                                          isCalculateHeight: Bool? = nil,
                                          options: NSStringDrawingOptions? = nil,
                                          paragraphStyle: NSParagraphStyle? = nil) -> CGSize {
        var tempFont: UIFont?
        if let newFont = font {
            tempFont = newFont
        }
        if let newFontSize = fontSize {
            if let newFontFamily = fontFamily {
                tempFont = UIFont(name: newFontFamily, size: newFontSize)
            } else {
                tempFont = .systemFont(ofSize: newFontSize, weight: weight ?? .regular)
            }
        }
        
        var tempSize: CGSize = .zero
        if let newContentMaxWH = contentMaxWH {
            if let newIsCalculateHeight = isCalculateHeight {
                if newIsCalculateHeight {
                    tempSize = CGSize(width: newContentMaxWH, height: CGFloat(MAXFLOAT))
                } else {
                    tempSize = CGSize(width: CGFloat(MAXFLOAT), height: newContentMaxWH)
                }
            } else {
                tempSize = CGSize(width: newContentMaxWH, height: CGFloat(MAXFLOAT))
            }
        }
        
        var attributes: [NSAttributedString.Key : Any]?
        if let newParagraphStyle = paragraphStyle {
            attributes = [NSAttributedString.Key.font: tempFont as Any,
                          NSAttributedString.Key.paragraphStyle: newParagraphStyle]
        } else {
            attributes = [NSAttributedString.Key.font: tempFont as Any]
        }

        let option = NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue
        let contentSize = NSString(string: content).boundingRect(with: tempSize,
                                                                 options: options ?? NSStringDrawingOptions(rawValue: option),
                                                                 attributes: attributes,
                                                                 context: nil).size
        return contentSize
    }
    
    /// String - 获取字符串尺寸（CGSize）
    public func jjc_getContentSize(font: UIFont? = nil,
                                   fontFamily: String? = nil,
                                   fontSize: CGFloat? = nil,
                                   weight: UIFont.Weight? = nil,
                                   size: CGSize,
                                   options: NSStringDrawingOptions? = nil,
                                   paragraphStyle: NSParagraphStyle? = nil) -> CGSize {
        String.jjc_getContentSize(self,
                                  font: font,
                                  fontFamily: fontFamily,
                                  fontSize: fontSize,
                                  weight: weight,
                                  size: size,
                                  options: options,
                                  paragraphStyle: paragraphStyle)
    }
    
    /// String - 获取字符串尺寸
    public func jjc_getContentSize(font: UIFont? = nil,
                                   fontFamily: String? = nil,
                                   fontSize: CGFloat? = nil,
                                   weight: UIFont.Weight? = nil,
                                   contentMaxWH: CGFloat? = nil,
                                   isCalculateHeight: Bool? = nil,
                                   options: NSStringDrawingOptions? = nil,
                                   paragraphStyle: NSParagraphStyle? = nil) -> CGSize {
        String.jjc_getContentSize(self,
                                  font: font,
                                  fontFamily: fontFamily,
                                  fontSize: fontSize,
                                  weight: weight,
                                  contentMaxWH: contentMaxWH,
                                  isCalculateHeight: isCalculateHeight,
                                  options: options,
                                  paragraphStyle: paragraphStyle)
    }
}
