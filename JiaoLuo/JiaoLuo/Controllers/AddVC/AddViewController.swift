//
//  AddViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/7/31.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit

protocol PageTurnDelegate: class {
    func pageTurn2FeedsVC(_ target: UIViewController)
}

class AddViewController: UIViewController {
    // sb 跳转代码控制
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "turn2Text" {
            (segue.destination as! RichTextInputViewController).turnPageDelegate = self
        }
        if segue.identifier == "turn2Voice" {
            (segue.destination as! VoiceInputViewController).turnPageDelegate = self
        }
        if segue.identifier == "turn2Image" {
            (segue.destination as! ImageInputViewController).turnPageDelegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initConfig()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initConfig() {
        // 移除底部tabbar
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        // 修改导航控制器tint色值
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
   
    //MARK: - ButtonClickEvent
    @IBAction func textButtonClickEvent(_ sender: UIButton) {
        mLog(message: "文字输入")
//        let richTextVC = RichTextInputViewController()
//        richTextVC.turnPageDelegate = self
//        self.navigationController?.pushViewController(richTextVC, animated: true)
    }
    
    @IBAction func voiceButtonClickEvent(_ sender: UIButton) {
        mLog(message: "声音输入")
    }
    
    @IBAction func dismissClickEvent(_ sender: UIButton) {
        mLog(message: "消失")
        // TabBar相关属性恢复
        resetTabbarSelected(self)
    }
}
extension AddViewController: PageTurnDelegate {
    func pageTurn2FeedsVC(_ target: UIViewController) {
        target.navigationController?.popViewController(animated: false)
        // TabBar相关属性恢复
        resetTabbarSelected(self)
    }
}
