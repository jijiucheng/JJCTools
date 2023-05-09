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
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 修复 iOS 15 系统下，导航栏显示问题
        // 参考链接：https://baijiahao.baidu.com/s?id=1711749740139600655&wfr=spider&for=pc
        // 参考链接：https://www.jianshu.com/p/9e362ffba244
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance;
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
        
        if hidesBottomBarWhenPushed {
            navigationItem.leftBarButtonItem = UIBarButtonItem.jjc_params(image: UIImage(named: "base_back")!, target: self, action: #selector(backItemAction))
        }
    }
    
    deinit {
        JJC_Log("\(self) ********** 已经释放 **********")
    }
}

// MARK:- 按钮点击事件
extension JJCViewController {
    /// 返回按钮 点击事件
    @objc open func backItemAction() {
        navigationController?.popViewController(animated: true)
    }
}
