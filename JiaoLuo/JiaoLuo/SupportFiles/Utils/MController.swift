//
//  MTag.swift
//  ZXYQ
//
//  Created by brooks on 2018/4/3.
//  Copyright © 2018年 brooks. All rights reserved.
//

import Foundation

class MController {
    static let cell_ID = "cellID"
}

/// 获取当前时间
func getNowTime() -> String {
    // 获取当前时间
    let now = Date()
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "HH:mm:ss"
    // 返回当前时间
    return dformatter.string(from: now)
}
