//
//  Models.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/2.
//  Copyright © 2018年 brooks. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RealWeatherModel {
    var temperature: Float!    //温度
    var skycon: String!         //天气概况
    var speed: Float!          //风速
    var pm25: Float!              //pm25值
    
    
    init(json: JSON) {
        self.temperature = json["temperature"].float
        self.skycon = json["skycon"].string
        self.pm25 = json["pm25"].float
        self.speed = json["wind"]["speed"].float
    }
}
