//
//  JJCToolsTestsModel.swift
//  JJCToolsTests
//
//  Created by mxgx on 2023/7/25.
//

import Foundation

struct JJCToolsTestsBaseChildModel: Codable {
    var childString: String = "测试"
    var childBool: Bool = true
    var childInt: Int = 100
}

struct JJCToolsTestsBaseModel: Codable {
    var string1: String = ""
    var string2: String = "测试一下"
    var bool1: Bool = false
    var bool2: Bool = true
    var double1: Double = 1.23
    var int1: Int = 99
    var child = JJCToolsTestsBaseChildModel()
//    var tuple: (String, Any) = ("Key", 299)
//    var dict1: [String: Any] = ["key1": "value1", "key2": 22, "key3": false]
//    var array1 = [12, 23, 34, 45]
//    var array2: [[String: Any]] = [["key11": "value11", "key12": 12, "key13": false], ["key21": 12]]
//    var array3: [(String, Any)] = [("1", 1), ("2", false), ("3", 1.11)]
}
