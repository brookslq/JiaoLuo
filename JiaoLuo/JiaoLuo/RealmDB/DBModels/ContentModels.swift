//
//  ContentModels.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/9.
//  Copyright © 2018年 brooks. All rights reserved.
//

import Foundation
import RealmSwift

class TextContentModel: Object {
    @objc dynamic var textId: Int = 0           // id
    @objc dynamic var time: Date?               // 显示时间
    @objc dynamic var originTime: Date?         // 原始时间，用来排序
    @objc dynamic var subInfo: String?          // 天气，地点信息
    @objc dynamic var content: String?          // 内容
    @objc dynamic var isCollect = false         // 是否被收藏
    
    // 添加主键
    override static func primaryKey() -> String? {
        return "textId"
    }
    
    // id自增
    func incrementalID() -> Int {
        let realm = RealmManager.default.getDefaultRealm()
        let retNext = realm?.objects(TextContentModel.self).sorted(byKeyPath: "textId")
        let last = retNext?.last
        if (retNext?.count)! > 0 {
            let valor = last?.textId
            return valor! + 1
        } else {
            return 1
        }
    }
}