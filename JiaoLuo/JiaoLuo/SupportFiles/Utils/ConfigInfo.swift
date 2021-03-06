//
//  ConfigInfo.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/2.
//  Copyright © 2018年 brooks. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ConfigInfo {
    // 数据库名称
    static let JIAOLUO = "jiaoluo"
    
    // cell_id
    static let CELL_ID = "CELL_ID"
    
    // 彩云天气token
    static let WEATHER_TOKEN = "bWLuKCa0zi6CE62r"
    // 彩云天气API主url
    static let WEATHER_URL = "https://api.caiyunapp.com/v2/" + ConfigInfo.WEATHER_TOKEN + "/"
    // 天气状态
    static var WEATHER_STATE = ""
    // 地级市名字
    static var CITY = "迷城"
    // 经纬度
    static var LONGITUDE = ""
    static var LAITUDE = ""
    
    // 默认文字，Add
    static let ADD_TEXT: String = "这就用纯粹的文字，记录此刻！\n\n记忆会模糊，记录不会褪色。"
}
