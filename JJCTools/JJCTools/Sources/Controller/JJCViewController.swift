//
//  JJCViewController.swift
//  JJCTools
//
//  Created by mxgx on 2023/5/9.
//

/**
 * 权限控制：
 * - open : module 以外可以访问、重写或者继承；
 * - public: module 以外可以访问、不能重写或者继承；
 * - internal(默认)：当前 module 可用；
 * - fileprivate: 当前 file 可见；
 * - private：当前声明区域可见。
 */

import UIKit

open class JJCViewController: UIViewController {
    open var isOpenThemeColor = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        themeUI()
//        JJC_Noti_AddObserver(JJCTheme.shared.key_noti_theme_color, observer: self, selector: #selector(refreshThemeUI))
        
        setBackBarButtonItem(JJCTheme.shared.jjc_image_back())
        setUI()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
        JJC_Log("\(self) ********** 已经释放 **********")
    }
    
//    open override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        refreshThemeUI()
//    }
    
    open func setBackBarButtonItem(_ image: UIImage) {
        if hidesBottomBarWhenPushed {
            navigationItem.leftBarButtonItem = UIBarButtonItem.jjc_paramsByCustom(image: image, target: self, action: #selector(backItemAction))
        }
    }
    
    open func setUI() {}
    
//    @objc open func refreshThemeUI() {
//        DispatchQueue.main.async {
//            self.themeUI()
//        }
//    }
    
    fileprivate func themeUI() {
        JJCTheme.shared.jjc_setStatusColor(JJC_ThemeColor(.status))
        JJCTheme.shared.jjc_setNavigationBarColor(JJC_ThemeColor(.navigationBar), controller: self)
        JJCTheme.shared.jjc_setNavigationBarTitleColor(JJC_ThemeColor(.title), controller: self)
        self.view.backgroundColor = JJC_ThemeColor(.controller)
        
        // 修复 iOS 15 系统下，导航栏显示问题
        // 参考链接：https://baijiahao.baidu.com/s?id=1711749740139600655&wfr=spider&for=pc
        // 参考链接：https://www.jianshu.com/p/9e362ffba244
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = JJC_ThemeColor(.navigationBar)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: JJC_ThemeColor(.title)]
            // 设置导航栏底部线条颜色
            appearance.shadowColor = JJC_ThemeColor(.navigationShadow)
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        }
    }
}

extension JJCViewController {
    /// 监听浅色、深色模式变化
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        JJC_Log("当前主题模式1 ---- \(JJC_CurThemeMode().rawValue)")
        if UITraitCollection.current.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            JJC_Log("当前主题模式2 ---- \(JJC_CurThemeMode().rawValue)")
        }
    }
}

// MARK:- 按钮点击事件
extension JJCViewController {
    /// 返回按钮 点击事件
    @objc open func backItemAction() {
        navigationController?.popViewController(animated: true)
    }
}
