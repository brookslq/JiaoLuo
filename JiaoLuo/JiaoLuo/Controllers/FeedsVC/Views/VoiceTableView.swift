//
//  VoiceTableView.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/21.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class VoiceTableView: UITableView {

    var voiceModels: Results<VoiceContentModel>?
    var player: AVAudioPlayer?      // 播放器
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView()
        self.separatorStyle = .none
        self.backgroundColor = UIColor.ColorHex(hex: "EFEFF4")
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(UINib.init(nibName: "VoiceContentTableViewCell", bundle: nil), forCellReuseIdentifier: ConfigInfo.CELL_ID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func voiceButtonClickEvent(sender: UIButton) {
        if player != nil {
            player?.stop()
            player = nil
        }
        do {
            let path = voiceModels![sender.tag].musicUrl!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            player = try AVAudioPlayer(data: data)
            guard player != nil else {
                noticeTop("播放失败", autoClear: true, autoClearTime: 2)
                return
            }
            player?.play()
        } catch  {
            mLog(message: voiceModels![sender.tag].musicUrl!)
            mLog(message: error)
        }
//        player = try! AVAudioPlayer(contentsOf: URL(string: voiceModels![sender.tag].musicUrl!)!)
//        guard player != nil else {
//            noticeTop("播放失败", autoClear: true, autoClearTime: 2)
//            return
//        }
//        player?.play()
    }
    
}

extension VoiceTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard voiceModels != nil else {
            return 0
        }
        return (voiceModels?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ConfigInfo.CELL_ID, for: indexPath) as? VoiceContentTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ConfigInfo.CELL_ID) as? VoiceContentTableViewCell
        }
        tableView.rowHeight = 86
        cell?.selectionStyle = .none
//        cell?.contentLabel.text = textModels![indexPath.row].content
//        cell?.timeLabel.text = date2String(textModels![indexPath.row].time!)
//        cell?.subInfoLabel.text = textModels![indexPath.row].subInfo
        cell?.timeLabel.text = date2String(voiceModels![indexPath.row].time!)
        cell?.titleLabel.text = voiceModels![indexPath.row].title
        cell?.voiceButton.tag = indexPath.row
        cell?.voiceButton.addTarget(self, action: #selector(voiceButtonClickEvent), for: .touchUpInside)
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, actionIndexPath) in
            //删除操作
            mLog(message: "执行删除操作")
            //            self.dataAry.remove(at: actionIndexPath.row)
            RealmManager.default.deleteObject(self.voiceModels![indexPath.row])
            let realmDB = RealmManager.default.createDB(ConfigInfo.JIAOLUO, isReadOnly: false)
            self.voiceModels = realmDB?.objects(VoiceContentModel.self)
            self.reloadData()
        }
        var collectTitle = "收藏"
        if voiceModels![indexPath.row].isCollect {
            collectTitle = "已收藏"
        }
        let collectAction = UITableViewRowAction(style: .destructive, title: collectTitle) { (action, actionIndexPath) in
            if self.voiceModels![indexPath.row].isCollect {
                // 执行取消收藏
                _ = RealmManager.default.updateObject(type: VoiceContentModel.self, primaryKey: self.voiceModels![indexPath.row].voiceId, key: "isCollect", value: false)
            } else {
                // 执行收藏
                _ = RealmManager.default.updateObject(type: VoiceContentModel.self, primaryKey: self.voiceModels![indexPath.row].voiceId, key: "isCollect", value: true)
            }
        }
        collectAction.backgroundColor = UIColor.orange
        
        return [deleteAction, collectAction]
    }
    
    //尾部滑动事件按钮（左滑按钮）
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //创建“删除”事件按钮
        let delete = UIContextualAction(style: .normal, title: "删除") {
            (action, view, completionHandler) in
            //将对应条目的数据删除
            //删除操作
            mLog(message: "执行删除操作")
            RealmManager.default.deleteObject(self.voiceModels![indexPath.row])
            let realmDB = RealmManager.default.createDB(ConfigInfo.JIAOLUO, isReadOnly: false)
            self.voiceModels = realmDB?.objects(VoiceContentModel.self)
            self.setEditing(false, animated: true)
            self.reloadData()
        }
        delete.backgroundColor = UIColor.red
        // 创建“收藏”事件按钮
        var collectTitle = "收藏"
        if voiceModels![indexPath.row].isCollect {
            collectTitle = "已收藏"
        }
        let collect = UIContextualAction(style: .normal, title: collectTitle) {
            (action, view, completionHandler) in
            if self.voiceModels![indexPath.row].isCollect {
                // 执行取消收藏
                _ = RealmManager.default.updateObject(type: VoiceContentModel.self, primaryKey: self.voiceModels![indexPath.row].voiceId, key: "isCollect", value: false)
                action.title = "收藏"
                
            } else {
                // 执行收藏
                _ = RealmManager.default.updateObject(type: VoiceContentModel.self, primaryKey: self.voiceModels![indexPath.row].voiceId, key: "isCollect", value: true)
                action.title = "取消收藏"
            }
            self.setEditing(false, animated: true)
            
        }
        collect.backgroundColor = UIColor.orange
        //返回所有的事件按钮
        let configuration = UISwipeActionsConfiguration(actions: [delete, collect])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mLog(message: "点击")
    }
}

