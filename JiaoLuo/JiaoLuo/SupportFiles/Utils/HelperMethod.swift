//
//  HelperMethod.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/9.
//  Copyright © 2018年 brooks. All rights reserved.
//

import Foundation
import RealmSwift

/// 字符串转日期
public func string2Date(_ target: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateTime = dateFormatter.date(from: target)
    return dateTime!
}

/// 日期转字符串
public func date2String(_ target: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateTime = dateFormatter.string(from: target)
    return dateTime
}
