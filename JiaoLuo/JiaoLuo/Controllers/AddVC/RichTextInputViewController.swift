//
//  RichTextInputViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/1.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit
import EDHInputAccessoryView

class RichTextInputViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initConfig()
        
    }

    
    func initConfig() {
        self.view.backgroundColor = UIColor.white
        
        let myTextView = UITextView(frame: CGRect(x: 0, y: 20, width: view.width, height: view.height - 20))
        myTextView.inputAccessoryView = EDHInputAccessoryView(textView: myTextView)
        view.addSubview(myTextView)
   
    }
}
