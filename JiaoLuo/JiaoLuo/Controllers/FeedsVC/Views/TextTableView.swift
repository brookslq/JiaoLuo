//
//  TextTableView.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/10.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit
import RealmSwift

protocol TextTableViewDelegate: class {
    func cellDidSelectedEvent(_ textModel: TextContentModel)
}

class TextTableView: UITableView {

    var textModels: Results<TextContentModel>?
    weak var textTVDelegate: TextTableViewDelegate!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView()
        self.separatorStyle = .none
        self.backgroundColor = UIColor.ColorHex(hex: "EFEFF4")
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(UINib.init(nibName: "TextContentTableViewCell", bundle: nil), forCellReuseIdentifier: ConfigInfo.CELL_ID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TextTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard textModels != nil else {
            return 0
        }
        return (textModels?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ConfigInfo.CELL_ID, for: indexPath) as? TextContentTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ConfigInfo.CELL_ID) as? TextContentTableViewCell
        }
        tableView.rowHeight = 108
        cell?.selectionStyle = .none
        cell?.contentLabel.text = textModels![indexPath.row].content
        cell?.timeLabel.text = date2String(textModels![indexPath.row].time!)
        cell?.subInfoLabel.text = textModels![indexPath.row].subInfo
         
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, actionIndexPath) in
            //删除操作
            mLog(message: "执行删除操作")
//            self.dataAry.remove(at: actionIndexPath.row)
            RealmManager.default.deleteObject(self.textModels![indexPath.row])
            let realmDB = RealmManager.default.createDB(ConfigInfo.JIAOLUO, isReadOnly: false)
            self.textModels = realmDB?.objects(TextContentModel.self)
            self.reloadData()
        } 
        var collectTitle = "收藏"
        if textModels![indexPath.row].isCollect {
            collectTitle = "已收藏"
        }
        let collectAction = UITableViewRowAction(style: .destructive, title: collectTitle) { (action, actionIndexPath) in
            if self.textModels![indexPath.row].isCollect {
                // 执行取消收藏
                _ = RealmManager.default.updateObject(type: TextContentModel.self, primaryKey: self.textModels![indexPath.row].textId, key: "isCollect", value: false)
            } else {
                // 执行收藏
                _ = RealmManager.default.updateObject(type: TextContentModel.self, primaryKey: self.textModels![indexPath.row].textId, key: "isCollect", value: true)
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
            RealmManager.default.deleteObject(self.textModels![indexPath.row])
            let realmDB = RealmManager.default.createDB(ConfigInfo.JIAOLUO, isReadOnly: false)
            self.textModels = realmDB?.objects(TextContentModel.self)
            self.setEditing(false, animated: true)
            self.reloadData()
        }
        delete.backgroundColor = UIColor.red
        // 创建“收藏”事件按钮
        var collectTitle = "收藏"
        if textModels![indexPath.row].isCollect {
            collectTitle = "已收藏"
        }
        let collect = UIContextualAction(style: .normal, title: collectTitle) {
            (action, view, completionHandler) in
            if self.textModels![indexPath.row].isCollect {
                // 执行取消收藏
                _ = RealmManager.default.updateObject(type: TextContentModel.self, primaryKey: self.textModels![indexPath.row].textId, key: "isCollect", value: false)
                action.title = "收藏"
                
            } else {
                // 执行收藏
                _ = RealmManager.default.updateObject(type: TextContentModel.self, primaryKey: self.textModels![indexPath.row].textId, key: "isCollect", value: true)
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
        textTVDelegate.cellDidSelectedEvent(textModels![indexPath.row])
    }
}
