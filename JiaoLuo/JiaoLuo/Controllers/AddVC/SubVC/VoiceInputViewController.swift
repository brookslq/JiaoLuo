//
//  VoiceInputViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/20.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit

class VoiceInputViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    weak var turnPageDelegate: PageTurnDelegate!
    
    let baseLayer = CALayer()
    var animation: CAKeyframeAnimation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
        musicAnimation()
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
    
    @IBAction func voiceButtonClickEvent(_ sender: UIButton) {
        if sender.isSelected {
            baseLayer.removeAllAnimations()
        } else {
            musicAnimation()
            baseLayer.add(animation, forKey: nil)
        }
        
        sender.isSelected = !sender.isSelected
    }
  
    @IBAction func saveButtonClickEvent(_ sender: UIButton) {
    }
    
    
    @IBAction func deleteButtonClickEvent(_ sender: UIButton) {
    }
}

// MARK: - 声音动画
extension VoiceInputViewController {
    func musicAnimation() {
        // 背景layer
        let musicLayer = CALayer()
        musicLayer.frame = CGRect(x: (view.width - 240) / 2, y: 120, width: 260, height: 320)
        musicLayer.backgroundColor = UIColor.white.cgColor
        self.view.layer.addSublayer(musicLayer)

        // 创建baselayer
        baseLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 100)
        baseLayer.cornerRadius = 2
        baseLayer.backgroundColor = UIColor.black.cgColor
        baseLayer.anchorPoint = CGPoint(x: 0, y: 1)
        baseLayer.position = CGPoint(x: 10, y: musicLayer.bounds.width)
        
        //创建复制layer
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = 6
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0)
        replicatorLayer.instanceDelay = 0.1
        replicatorLayer.instanceRedOffset -= 0.1
        replicatorLayer.addSublayer(baseLayer)
        musicLayer.addSublayer(replicatorLayer)
        
        animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        animation.duration = 1
        animation.values = [1, 0.5, 0]
        animation.repeatCount = HUGE
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
//        animation.keyPath = "music"
//        baseLayer.add(animation, forKey: nil)
    }
    
}

















