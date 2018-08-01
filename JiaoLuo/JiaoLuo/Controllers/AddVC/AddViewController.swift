//
//  AddViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/7/31.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit
import CLImagePickerTool

class AddViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        initConfig()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initConfig() {
        //移除底部tabbar
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
    }
   
    //MARK: - ButtonClickEvent
    @IBAction func textButtonClickEvent(_ sender: UIButton) {
        mLog(message: "文字输入")
        let richTextVC = RichTextInputViewController()
        self.navigationController?.pushViewController(richTextVC, animated: true)
    }
    @IBAction func voiceButtonClickEvent(_ sender: UIButton) {
        mLog(message: "声音输入")
        
    }
    @IBAction func photoButtonClickEvent(_ sender: UIButton) {
        mLog(message: "照片")
        let imagePicker = CLImagePickersTool()
        imagePicker.singleImageChooseType = .singlePicture
        imagePicker.isHiddenVideo = true
        imagePicker.singleModelImageCanEditor = true
        imagePicker.setupImagePickerWith(MaxImagesCount: 6, superVC: self) { (asset,cutImage) in
            
        }
    }
    
    @IBAction func dismissClickEvent(_ sender: UIButton) {
        mLog(message: "消失")
        // TabBar相关属性恢复
        self.tabBarController?.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
        self.automaticallyAdjustsScrollViewInsets = true
        // 默认回Feeds
        self.tabBarController?.selectedIndex = 0
    }
}

