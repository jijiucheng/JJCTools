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
        jjc_setTopLineColor(JJC_RGBA_255(230, 230, 230))
        jjc_addAllChildController()
    }
}

extension JJCTabBarController {
    /// 设置 TabBar 顶部分割线颜色
    /// 参考链接：https://www.jianshu.com/p/5a63ad6229fd
    @objc open func jjc_setTopLineColor(_ color: UIColor?) {
        if let tempColor = color {
            let view = UIView(frame: CGRect(x: 0, y: -0.5, width: tabBar.bounds.width, height: 0.5))
            view.backgroundColor = tempColor
            UITabBar.appearance().insertSubview(view, at: 0)
            
//            UITabBar.appearance().shadowImage = UIImage()
//            UITabBar.appearance().backgroundImage = UIImage()
//            UITabBar.appearance().backgroundColor = UIColor.white
//            
//            let redLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 1))
//            redLine.backgroundColor = tempColor
//
//            UIGraphicsBeginImageContextWithOptions(tabBar.bounds.size, false, 0)
//            redLine.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            UITabBar.appearance().backgroundImage = image
        }
    }
    
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
