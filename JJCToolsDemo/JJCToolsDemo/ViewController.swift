//
//  ViewController.swift
//  JJCToolsDemo
//
//  Created by mxgx on 2024/7/11.
//

import UIKit
import JJCTools

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let imageV = UIImageView(frame: CGRectMake(100, 100, 200, 200))
        imageV.backgroundColor = JJCToolsAssets.jjc_bundleColor("base_lastChapterColor")
        imageV.image = JJCToolsAssets.jjc_bundleImage("base_back")
        view.addSubview(imageV)
    }
}

