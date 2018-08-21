//
//  VoiceInputViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/20.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

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
    var tempTime: String?           // 临时存储记录时间被清空前的数值
    // 提示框
    var alertController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
        musicAnimation()
        initRecorder()
        initAlert()
    }
    
    func initConfig() {
        title = "音·记"
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonClick))
        backButton.image = #imageLiteral(resourceName: "arrow_back")
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func initRecorder() {
        // 初始化录音器
        let session = AVAudioSession.sharedInstance()
        // 设置录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        // 设置支持后台
        try! session.setActive(true)
        // 获取Document目录
//        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
//                                                         .userDomainMask, true).first
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.string(from: currentTime)
        
        // 录音文件路径
        aacPath = docDir! + "/jiaoluo/voice/\(recordingName).wav"
        recorderSeetingDic =
            [
                AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),  // 音频格式
                AVNumberOfChannelsKey: 2, // 双声道
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey: 320000,
                AVSampleRateKey: 44100.0 // 录音器每秒采集的录音样本数
        ]
    }
    
    // 初始化提示框
    func initAlert() {
        alertController = UIAlertController(title: "录音保存",
                                                message: "请输入标题和标签", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "标题"
        }
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "标签(用#分隔)"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let title = self.alertController.textFields!.first!
            let tags = self.alertController.textFields!.last!
            mLog(message: "标题：\(title.text!) 标签：\(tags.text!)")
            
            
            // 存储数据
            let voiceModel = VoiceContentModel()
            voiceModel.voiceId = voiceModel.incrementalID()
            voiceModel.voiceLong = self.tempTime
            voiceModel.time = string2Date(getNowTime())
            voiceModel.originTime = Date()
            voiceModel.musicUrl = self.aacPath
            voiceModel.title = title.text
            voiceModel.tags = tags.text
            RealmManager.default.addObject(voiceModel, update: false, result: { error in
                mLog(message: error.debugDescription)
            })
            // 重置时间计时和动画
            //            self.resetTimeAndAnimation()
            self.stopRecorder()
            self.turnPageDelegate.pageTurn2FeedsVC(self)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
    }
    
    // 开始录音
    func startRecorder() {
        
        guard recorder != nil else {
 
            // 初始化录音器
            recorder = try! AVAudioRecorder(url: URL(fileURLWithPath: aacPath!), settings: recorderSeetingDic!)
            if recorder != nil {
                recorder?.prepareToRecord()
                recorder?.record()
            }
            return
        }
        recorder?.record()
    }
    
    // 暂停录音
    func stopRecorder() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                mLog(message: "正在录音，马上结束，并保存至：\(aacPath!)")
            } else {
                mLog(message: "没有录音……")
            }
        }
        
        // 停止录音
        recorder?.stop()
        recorder = nil
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
            stopRecorder()
        } else {
            musicAnimation()
            baseLayer.add(animation, forKey: nil)
            buttonIsHidden(false)
            // 时间同步改变
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            startRecorder()
        }
        
        sender.isSelected = !sender.isSelected
    }
  
    /// 设置两个功能按钮是否隐藏
    func buttonIsHidden(_ isHidden: Bool) {
        saveButton.isHidden = isHidden
        deleteButton.isHidden = isHidden
    }
    
    @IBAction func saveButtonClickEvent(_ sender: UIButton) {
//        // 存储数据
//        let voiceModel = VoiceContentModel()
//        voiceModel.voiceId = voiceModel.incrementalID()
//        voiceModel.voiceLong = timeLabel.text
//        voiceModel.time = string2Date(getNowTime())
//        voiceModel.originTime = Date()
//        voiceModel.musicUrl = aacPath
//        RealmManager.default.addObject(voiceModel, update: false, result: { error in
//            mLog(message: error.debugDescription)
//            self.stopRecorder()
//        })
//        // 重置时间计时和动画
//        resetTimeAndAnimation()
//        turnPageDelegate.pageTurn2FeedsVC(self)
        tempTime = timeLabel.text
        resetTimeAndAnimation()
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButtonClickEvent(_ sender: UIButton) {
        resetTimeAndAnimation()
        // 释放录音
        stopRecorder()
        recorder = nil
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

















