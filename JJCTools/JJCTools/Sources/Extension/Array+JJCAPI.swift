//
//  Array+JJCAPI.swift
//  JJCTools
//
//  Created by mxgx on 2023/3/22.
//

import Foundation

extension Array {
    /// Array - 数组将被拆分成多个指定长度数组的二级数组
    static func split<T>(_ array: [T], length: Int) -> [[T]] {
        var result = [[T]]()
        let row = array.count % length == 0 ? (array.count / length) : (array.count / length + 1)
        for index in 0..<row {
            var tempArray = [T]()
            for subIndex in 0..<length {
                let curTotalIndex = index * length + subIndex
                if curTotalIndex >= array.count {
                    break
                }
                tempArray.append(array[curTotalIndex])
            }
            result.append(tempArray)
        }
        return result
    }
    
    /// Array - 数组将被拆分成多个指定长度数组的二级数组
    public func jjc_split(_ length: Int) -> [Array] {
        return Array.split(self, length: length)
    }
}
