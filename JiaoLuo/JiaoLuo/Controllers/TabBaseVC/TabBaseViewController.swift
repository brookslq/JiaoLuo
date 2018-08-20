//
//  ViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/7/26.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit

class TabBaseViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
    }

    func initConfig() {
        // 被选中的VC
        selectedIndex = 0
        // 设置tintColor
        UITabBar.appearance().tintColor = .black
    }
    
}

// MARK: - Tabbar相关方法
func resetTabbarSelected(_ target: UIViewController) {
    target.tabBarController?.hidesBottomBarWhenPushed = false
    target.tabBarController?.tabBar.isHidden = false
    target.automaticallyAdjustsScrollViewInsets = true
    target.tabBarController?.selectedIndex = 0
}
