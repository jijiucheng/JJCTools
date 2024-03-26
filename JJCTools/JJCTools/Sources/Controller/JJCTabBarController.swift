//
//  JJCTabBarController.swift
//  JJCTools
//
//  Created by mxgx on 2024/3/26.
//

import UIKit

open class JJCTabBarController: UITabBarController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 0
        jjc_addAllChildController()
    }
}

extension JJCTabBarController {
    /// 添加所有子视图
    @objc open func jjc_addAllChildController() {}
    
    /// 添加子视图
    @objc open func jjc_addChildController(_ childVC: UIViewController, normalImage: UIImage?, selectedImage: UIImage?, title: String?, titleColor: UIColor?, titleFont: UIFont?, selectTitle: String?, selectTitleColor: UIColor?, selectTitleFont: UIFont?) {
        let nav = JJCNavigationController(rootViewController: childVC)
        nav.tabBarItem.image = normalImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title
        if let tempTitleColor = titleColor {
            nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: tempTitleColor], for: .normal)
        }
        if let tempTitleFont = titleFont {
            nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: tempTitleFont], for: .normal)
        }
        if let tempTitleColor = selectTitleColor {
            nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: tempTitleColor], for: .selected)
        }
        if let tempTitleFont = selectTitleFont {
            nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: tempTitleFont], for: .selected)
        }
        
        addChild(nav)
    }
}
