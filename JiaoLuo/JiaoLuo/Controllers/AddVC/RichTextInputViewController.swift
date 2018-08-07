//
//  RichTextInputViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/1.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit
import EDHInputAccessoryView
import CoreLocation
import RxSwift
import RxCocoa

class RichTextInputViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionInfoLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentViewBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    var doneButton: UIBarButtonItem!

    weak var turnPageDelegate: PageTurnDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
    }

    @objc func doneButtonClick() {
        let textStr = contentTextView.text
        guard (textStr?.count)! > 0 else {
            noticeInfo("先记录", autoClear: true, autoClearTime: 1)
            contentTextView.resignFirstResponder()
            return
        }
        contentTextView.resignFirstResponder()
    }
    
    @objc func backButtonClick() {
        turnPageDelegate.pageTurn2FeedsVC(self)
    }
    
    func initConfig() {
        // 导航栏
        self.title = "文记"
        doneButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(doneButtonClick))
        self.navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonClick))
        backButton.image = #imageLiteral(resourceName: "arrow_back")
        self.navigationItem.leftBarButtonItem = backButton
        
        // UI
        self.view.backgroundColor = UIColor.white
        timeLabel.text = getNowTime()

        
        descriptionInfoLabel.text = ConfigInfo.WEATHER_STATE + "·" + ConfigInfo.CITY
        
  
        contentTextView.inputAccessoryView = EDHInputAccessoryView(textView: contentTextView)
        contentTextView.tintColor = UIColor.black
//        contentTextView.layoutManager.allowsNonContiguousLayout = false
        
        saveButton.layer.backgroundColor = UIColor.black.cgColor
        saveButton.layer.cornerRadius = 15
        saveButton.layer.masksToBounds = true
        
        //键盘即将弹出
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //键盘即将隐藏
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @IBAction func saveButtonClick(_ sender: UIButton) {
        turnPageDelegate.pageTurn2FeedsVC(self)
    }
    //键盘弹出监听
    @objc func keyboardShow(note: Notification)  {
        guard let userInfo = note.userInfo else {return}
        guard let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else{return}
        contentViewBottomConstrain.constant = keyboardRect.height - 56
        doneButton.title = "完成"
        doneButton.isEnabled = true
        mLog(message: "键盘弹起，并修改编辑处的高度")
    }
    
    //键盘隐藏监听
    @objc func keyboardHidden(note: Notification){
        contentViewBottomConstrain.constant = 8
        doneButton.title = ""
        doneButton.isEnabled = false
        mLog(message: "键盘消失，并修改编辑处的高度")
    }
    
    //取消键盘监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


































