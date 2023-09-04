//
//  JJCToolsTests.swift
//  JJCToolsTests
//
//  Created by mxgx on 2023/3/18.
//

/**
 * 单元测试
 * - 参考链接：https://www.jianshu.com/p/eeed010fc889
 */

import XCTest
@testable import JJCTools

/// 所有的测试类需要继承 XCTestCase
final class JJCToolsTests: XCTestCase {
    /// 在每一个测试方法调用前，都会被调用；用来初始化 test 用例的一些初始值
    /// setUp 方法会在 XCTestCase 的测试方法每次调用之前调用，所以可以把一些测试代码需要用的初始化代码和全局变量写在这个方法里;
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // 在这里设置代码。在调用类中的每个测试方法之前调用此方法。
    }

    /// 在每一个测试方法调用后，都会被调用；用来重置 test 方法的数值
    /// 在每个单元测试方法执行完毕后，XCTest 会执行 tearDown 方法，所以可以把需要测试完成后销毁的内容写在这个里，以便保证下面的测试不受本次测试影响
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // 在这里输入删除代码。在调用类中的每个测试方法之后调用此方法。
    }

    /// 测试方法命名以 test 开始
    /// 所有测试的方法都需要以test为前缀进行命名
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        // 这是一个功能测试用例。
        // 使用XCTAssert和相关函数来验证您的测试产生正确的结果。
    }

    /// 性能测试
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        // 这是一个性能测试用例。
        self.measure {
            // Put the code you want to measure the time of here.
            // 把你想要测量时间的代码放在这里。
        }
    }

}
