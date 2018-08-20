//
//  TextShowViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/20.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit

class TextShowViewController: UIViewController {
    
    
    @IBOutlet weak var timeInfo: UILabel!
    @IBOutlet weak var subInfo: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var textModel: TextContentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initConfig()
    }

    func initConfig() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        title = "记忆·文字"
        
        timeInfo.text = date2String(textModel.time!)
        subInfo.text = textModel.subInfo
        contentTextView.text = textModel.content
        
        contentTextView.font = UIFont.systemFont(ofSize: 18)
    }
}
