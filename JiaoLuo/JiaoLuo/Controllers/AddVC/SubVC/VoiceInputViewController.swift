//
//  VoiceInputViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/20.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit

class VoiceInputViewController: UIViewController {

    weak var turnPageDelegate: PageTurnDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initConfig()
    }
    
    func initConfig() {
        title = "音·记"
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonClick))
        backButton.image = #imageLiteral(resourceName: "arrow_back")
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func backButtonClick() {
        turnPageDelegate.pageTurn2FeedsVC(self)
    }
}
