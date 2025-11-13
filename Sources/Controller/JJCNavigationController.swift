//
//  JJCNavigationController.swift
//  JJCTools
//
//  Created by mxgx on 2023/5/9.
//

import UIKit

open class JJCNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 系统返回手势
        interactivePopGestureRecognizer?.delegate = self
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
