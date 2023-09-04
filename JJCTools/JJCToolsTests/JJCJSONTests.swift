//
//  JJCJSONTests.swift
//  JJCToolsTests
//
//  Created by mxgx on 2023/7/24.
//

import XCTest
import JJCTools

final class JJCJSONTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - 自定义测试用例
    func testCustomExample() throws {
//        let array1 = ["1", "2", "3"]
//        let jsonString1 = JJCJSON.jjc_jsonString(array1)
//        print("jsonString1 = \(String(describing: jsonString1))")
//        let result1 = jsonString1 == "[\"1\",\"2\",\"3\"]"
//        XCTAssert(result1, "测试 jsonString1 Any -> jsonString 结果报错")
//
//        let dict1 = ["key1": "value1", "key2": "value2"]
//        let jsonString2 = JJCJSON.jjc_jsonString(dict1)
//        print("jsonString2 = \(String(describing: jsonString2))")
//        let result2 = jsonString2 == "{\"key1\":\"value1\",\"key2\":\"value2\"}" || jsonString2 == "{\"key2\":\"value2\",\"key1\":\"value1\"}"
//        XCTAssert(result2, "测试 jsonString2 Any -> jsonString 结果报错")
        
//        let model1 = JJCToolsTestsBaseModel()
//        let jsonString3 = JJCJSON.jjc_jsonString(model1)
//        print("jsonString3 = \(String(describing: jsonString3))")
//        let result3 = jsonString3 == "{\n  \"string1\" : \"\",\n  \"double1\" : 1.23,\n  \"bool2\" : true,\n  \"child\" : {\n    \"childString\" : \"测试\",\n    \"childBool\" : true,\n    \"childInt\" : 100\n  },\n  \"string2\" : \"测试一下\",\n  \"bool1\" : false,\n  \"int1\" : 99\n}"
//        XCTAssert(result3, "测试 jsonString3 Any -> jsonString 结果报错")
        
        let model2 = JJCToolsTestsBaseModel()
        let jsonString4 = JJCJSON.jjc_jsonString(model2)
        print("jsonString4 = \(String(describing: jsonString4))")
        let dict2 = JJCJSON.jjc_encode(model2, resultType: [String: Any].self)
        print("dict2 = \(String(describing: dict2))")
        let array1 = JJCJSON.jjc_encode([model2, model2, model2], resultType: [[String, Any]].self)
        print("array1 = \(String(describing: array1))")
    }
}
