//
//  JJCToolsDemoTests.swift
//  JJCToolsDemoTests
//
//  Created by mxgx on 2024/7/11.
//

import XCTest
@testable import JJCToolsDemo
import JJCTools

final class JJCToolsDemoTests: XCTestCase {

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
        
        /// JJCApp
        let isUpdate = JJCApp.jjc_checkIsUpdateVersion(oldRelease: "1.2.0", oldDebug: "001", newRelease: "1.2.0", newDebug: "002")
        print("xxx")
        XCTAssert(true, "[单元测试] JJCApp - jjc_checkIsUpdateVersion - \(isUpdate)")
        
        
        // JJCLocal
        let local = JJC_Local("Tips", "温馨提示", bundle: Bundle(for: JJCToolsDemoTests.self), lproj: nil)
        print("xxx")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
