//
//  UITableView+JJCAPI.swift
//  JJCTools
//
//  Created by mxgx on 2023/7/20.
//

import Foundation
import UIKit

extension UITableView {
    /// UITableView - 关闭隐式动画刷新
    public func reloadByDisableActions() {
        CATransaction.setDisableActions(true)
        self.reloadData()
        CATransaction.commit()
    }
}
