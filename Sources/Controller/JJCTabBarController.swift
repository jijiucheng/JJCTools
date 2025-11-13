//
//  JJCTabBarController.swift
//  JJCTools
//
//  Created by mxgx on 2024/3/26.
//

/*
 1、修改 UITabBar 文字颜色：
 - iOS10 之后，修改 UITabBar 的文字颜色，通过 unselectedItemTintColor、tintColor；
 - 通过 tabBarItem.setTitleTextAttributes 的方式修改，最开始是有效的，但是当从子界面返回到根界面的时候，文字颜色又会被重置为系统颜色，尤其是选中状态下会变成系统蓝色；
 - 或者可以通过 viewWillAppear 监听根控制器界面显示，重新设置为所需颜色，此种方式适合 UITabBar 文字颜色不统一的情况：
     if let tabBarController = self.tabBarController {
         for item in tabBarController.tabBar.items ?? [] {
             item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normalColor], for: .normal)
             item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
         }
     }
 */

import UIKit

open class JJCTabBarController: UITabBarController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 设置默认选中文字颜色
        UITabBar.appearance().tintColor = JJC_HexColorA("#282828")
        UITabBar.appearance().unselectedItemTintColor = JJC_HexColorA("#282828")
        
        selectedIndex = 0
        jjc_setTopLineColor(JJC_RGBA_255(230, 230, 230))
        jjc_addAllChildController()
    }
    
    /// 设置 TabBar 顶部分割线颜色
    /// 参考链接：https://www.jianshu.com/p/5a63ad6229fd
    @objc open func jjc_setTopLineColor(_ color: UIColor?) {
        if let tempColor = color {
            let view = UIView(frame: CGRect(x: 0, y: -0.5, width: tabBar.bounds.width, height: 0.5))
            view.backgroundColor = tempColor
            UITabBar.appearance().insertSubview(view, at: 0)
            
            // 去除毛玻璃色
            tabBar.backgroundColor = .white
            //            let customBgView = UIView(frame: tabBar.bounds)
            //            customBgView.backgroundColor = .white
            //            UITabBar.appearance().insertSubview(customBgView, at: 0)
            
            
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
    open func jjc_addChildController(_ nav: UINavigationController, image: (normal: UIImage?, selected: UIImage?)?, normalTitle: (title: String?, color: UIColor?, font: UIFont?)?, selectedTitle: (title: String?, color: UIColor?, font: UIFont?)?) {
        nav.tabBarItem.image = image?.normal
        nav.tabBarItem.selectedImage = image?.selected
        nav.tabBarItem.title = normalTitle?.title
        if let normalColor = normalTitle?.color {
            nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normalColor], for: .normal)
        }
        if let normalFont = normalTitle?.font {
            nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        }
        if let selectedColor = selectedTitle?.color {
            nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        }
        if let selectedFont = selectedTitle?.font {
            nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: selectedFont], for: .selected)
        }
        addChild(nav)
    }
    
    /// 添加子视图 @objc
    @objc open func jjc_addChildController(_ nav: UINavigationController, normalImage: UIImage?, selectedImage: UIImage?, title: String?, titleColor: UIColor?, titleFont: UIFont?, selectTitle: String?, selectTitleColor: UIColor?, selectTitleFont: UIFont?) {
        self.jjc_addChildController(nav, image: (normalImage, selectedImage), normalTitle: (title, titleColor, titleFont), selectedTitle: (selectTitle, selectTitleColor, selectTitleFont))
    }
}
