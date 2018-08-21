//
//  VoiceInputViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/20.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceInputViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    weak var turnPageDelegate: PageTurnDelegate!
    
    // 时间记录
    @IBOutlet weak var timeLabel: UILabel!
    var timer: Timer!
    var countTime: Float = 0.00
    // 声音动画
    @IBOutlet weak var musicLayerView: UIView!
    let baseLayer = CALayer()
    var animation: CAKeyframeAnimation!
    // 录音
    var recorder: AVAudioRecorder?  // 录音器
    var player: AVAudioPlayer?      // 播放器
    var recorderSeetingDic: [String: Any]?  // 录音器设置参数数组
    var volumeTimer: Timer!         // 定时器线程，循环检测录音的音量大小
    var aacPath: String?            // 录音存储路径
    
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
            // 时间停止
            timer.invalidate()
            baseLayer.removeAllAnimations()
            buttonIsHidden(true)
        } else {
            musicAnimation()
            baseLayer.add(animation, forKey: nil)
            buttonIsHidden(false)
            
            // 时间同步改变
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
        
        sender.isSelected = !sender.isSelected
    }
  
    /// 设置两个功能按钮是否隐藏
    func buttonIsHidden(_ isHidden: Bool) {
        saveButton.isHidden = isHidden
        deleteButton.isHidden = isHidden
    }
    
    @IBAction func saveButtonClickEvent(_ sender: UIButton) {
        resetTimeAndAnimation()
    }
    
    
    @IBAction func deleteButtonClickEvent(_ sender: UIButton) {
        resetTimeAndAnimation()
    }
    
    // MARK: - 时间改变
    //count time
    @objc func updateTime() {
        countTime += 0.01
        timeLabel.text = String(format: "%.2f",countTime)
    }
    
    func resetTimeAndAnimation() {
        baseLayer.removeAllAnimations()
        timer.invalidate()
        countTime = 0.00
        timeLabel.text = "0.00"
        buttonIsHidden(true)
    }
}

// MARK: - 声音动画
extension VoiceInputViewController {
    func musicAnimation() {
        // 背景layer
        let musicLayer = CALayer()
        musicLayer.frame = CGRect(x: 0, y: 0, width: musicLayerView.width, height: musicLayerView.height)
        musicLayer.backgroundColor = UIColor.white.cgColor
        musicLayerView.layer.addSublayer(musicLayer)

        // 创建baselayer
        baseLayer.frame = CGRect(x: 0, y: 0, width: 10, height: musicLayerView.height)
        baseLayer.cornerRadius = 2
        baseLayer.backgroundColor = UIColor.black.cgColor
        baseLayer.anchorPoint = CGPoint(x: 0, y: 1)
        baseLayer.position = CGPoint(x: 10, y: musicLayerView.height)
        
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

















