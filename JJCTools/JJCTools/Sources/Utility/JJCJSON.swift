//
//  JJCJSON.swift
//  JJCTools
//
//  Created by mxgx on 2023/7/22.
//

/**
 * JJCJSON - 数据模型转换
 */

import UIKit

public class JJCJSON: NSObject {}

// MARK: - 转换成 JSON 对象
extension JJCJSON {
    /// JJCJSON - 类方法 - Any -> jsonData
    public class func jjc_jsonData(_ object: Any, encoding: String.Encoding = .utf8, outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted, writingOptions: JSONSerialization.WritingOptions = []) -> Data? {
        if let codableObject = object as? Codable {
            let encoder = JSONEncoder()
            encoder.outputFormatting = outputFormatting
            guard let jsonData = try? encoder.encode(codableObject) else { return nil }
            return jsonData
        } else {
            // 特殊处理：由于 String 在 JSONSerialization.isValidJSONObject = false 属于不可序列化的类型，所以此处需要单独处理
            if let data = (object as? String)?.data(using: encoding) { return data }
            guard JSONSerialization.isValidJSONObject(object) else { return nil }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: object, options: writingOptions) else { return nil }
            return jsonData
        }
    }
    
    /// JJCJSON - 类方法 - Any -> jsonString
    public class func jjc_jsonString(_ object: Any, encoding: String.Encoding = .utf8, outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted, writingOptions: JSONSerialization.WritingOptions = []) -> String? {
        guard let jsonData = jjc_jsonData(object, encoding: encoding, outputFormatting: outputFormatting, writingOptions: writingOptions) else { return nil }
        guard let jsonString = String(data: jsonData, encoding: encoding) else { return nil }
        return jsonString
    }
}

// MARK: - 数据、模型转换
extension JJCJSON {
    /// JJCJSON - 类方法 - Any -> Model
    public class func jjc_decode<T>(_ object: Any, encoding: String.Encoding = .utf8, outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted, writingOptions: JSONSerialization.WritingOptions = [], readingOptions: JSONSerialization.ReadingOptions = .mutableLeaves, resultType: T.Type) -> T? where T: Decodable {
        guard let jsonData = jjc_jsonData(object, encoding: encoding, outputFormatting: outputFormatting, writingOptions: writingOptions) else { return nil }
        if object is Codable {
            guard let result = try? JSONDecoder().decode(T.self, from: jsonData) else { return nil }
            return result
        } else {
            guard let result = try? JSONSerialization.jsonObject(with: jsonData, options: readingOptions) as? T else { return nil }
            return result
        }
    }
    
    /// JJCJSON - 类方法 - Model -> Any
    public class func jjc_encode<T>(_ object: Any, encoding: String.Encoding = .utf8, outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted, writingOptions: JSONSerialization.WritingOptions = [], readingOptions: JSONSerialization.ReadingOptions = .mutableLeaves, resultType: T.Type) -> T? {
        guard let jsonData = jjc_jsonData(object, encoding: encoding, outputFormatting: outputFormatting, writingOptions: writingOptions) else { return nil }
        guard let result = try? JSONSerialization.jsonObject(with: jsonData, options: readingOptions) as? T else { return nil }
        return result
    }
}
