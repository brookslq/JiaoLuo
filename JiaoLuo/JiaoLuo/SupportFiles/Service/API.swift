//
//  API.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/2.
//  Copyright © 2018年 brooks. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PKHUD

class API {
    //MARK: - 天气处理
    ///通过经纬度，获取当前天气状况数据
    func postCurrentWeatherData(_ longitude: String!, latitude: String!) {
        let url: String = ConfigInfo.WEATHER_URL + longitude + "," + latitude + "/realtime"
        mLog(message: url)
        HUD.show(.progress)
        Alamofire.request(url).responseJSON{ response in
            guard response.result.isSuccess else {
                mLog(message: response.error)
                HUD.hide()
                return
            }
            let jsonData = JSON(response.value!)
            let json = jsonData["result"]
            let realWeather = RealWeatherModel(json: json)
            let weatherNum = String(format: "%.0f", realWeather.temperature) + "°C"
            let skycon = DataProcesser().conversionEng2Ch(text: String(realWeather.skycon))
            ConfigInfo.WEATHER_STATE = weatherNum + " " + skycon
            HUD.hide()
        }
    }
}
