//
//  UIProgressView+JJCAPI.swift
//  JJCTools
//
//  Created by mxgx on 2024/7/11.
//

import Foundation
import UIKit

extension UIProgressView {
    /// UIProgressView - 设置高度缩放比 - 由于 UIProgressView 无法设置高度，默认 1x 2.0；2x 4.0；3x 6.0，可以通过缩放达到效果
    public func setScaleHeight(_ scale: CGFloat) {
        transform = CGAffineTransform(scaleX: 1.0, y: scale)
    }
}
