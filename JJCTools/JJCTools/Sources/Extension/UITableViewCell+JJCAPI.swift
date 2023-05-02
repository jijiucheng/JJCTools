//
//  UITableViewCell+JJCAPI.swift
//  JJCTools
//
//  Created by mxgx on 2023/5/2.
//

import Foundation
import UIKit

// MARK: - 给 section 添加圆角
/**
 调用：
 public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     cell.addSectionCorner(at: indexPath, radius: 12)
 }
 */
extension UITableViewCell {
    /// UITableViewCell - 获取当前 UITableView
    private func jjc_getTableView() -> UITableView? {
        if let tableView = self.superview as? UITableView {
            return tableView
        }
        if let tableView = self.superview?.superview as? UITableView {
            return tableView
        }
        return nil
    }
    
    /// UITableViewCell - 给 section 添加圆角
    public func jjc_addSectionCorner(at indexPath: IndexPath, radius: CGFloat) {
        let tableView = jjc_getTableView()!
        let rows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == 0 || indexPath.row == rows - 1 {
            var corner: UIRectCorner
            if rows == 1 {
                corner = UIRectCorner.allCorners
            } else if indexPath.row == 0 {
                let cornerRawValue = UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue
                corner = UIRectCorner(rawValue: cornerRawValue)
            } else {
                let cornerRawValue = UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue
                corner = UIRectCorner(rawValue: cornerRawValue)
            }
            let cornerLayer = CAShapeLayer()
            cornerLayer.masksToBounds = true
            cornerLayer.frame = self.bounds
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
            cornerLayer.path = path.cgPath
            self.layer.mask = cornerLayer
        } else {
            self.layer.mask = nil
        }
    }
}
