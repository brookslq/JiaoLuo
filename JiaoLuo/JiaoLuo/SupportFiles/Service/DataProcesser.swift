//
//  DataProcesser.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/2.
//  Copyright © 2018年 brooks. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DataProcesser {
    
    /************************************* 定位 *****************************************/
    
    //MARK: - LOCATION
    func setLocation(_ target: UIViewController) {
        let locationManager: CLLocationManager = CLLocationManager()
        //设置定位服务管理器代理
        locationManager.delegate = target as? CLLocationManagerDelegate
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        //发送授权申请
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            mLog(message: "定位开始")
            // 获取经纬度
            var longitude = locationManager.location?.coordinate.longitude.description
            var latitude = locationManager.location?.coordinate.latitude.description
            
            //如果出现nil的情况，赋默认值，防止程序奔溃
            if longitude == nil || latitude == nil {
                longitude = "-120"
                latitude = "36"
            }
            
            ConfigInfo.LONGITUDE = longitude!
            ConfigInfo.LAITUDE = latitude!
            // 地理编码解析里面有个闭包
            DataProcesser().reverseGeocode(latitude: Double(latitude!)!, longitude: Double(longitude!)!)
            API().postCurrentWeatherData(ConfigInfo.LONGITUDE, latitude: ConfigInfo.LAITUDE)
        }
    }
    
    ///地理信息反编码
    func reverseGeocode(latitude: Double, longitude: Double){
        let geocoder = CLGeocoder()
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            //强制转成简体中文
            let array = NSArray(object: "zh-hans")
            UserDefaults.standard.set(array, forKey: "AppleLanguages")
            //显示所有信息
            if error != nil {
                print("错误：\(error?.localizedDescription ?? "未知"))")
                return
            }
            
            if let p = placemarks?[0]{
                //                print(p) //输出反编码信息
                var address = ""
                
                if let country = p.country {
                    address.append("国家：\(country)\n")
                }
                if let administrativeArea = p.administrativeArea {
                    address.append("省份：\(administrativeArea)\n")
                }
                if let subAdministrativeArea = p.subAdministrativeArea {
                    address.append("其他行政区域信息（自治区等）：\(subAdministrativeArea)\n")
                }
                if let locality = p.locality {
                    address.append("城市：\(locality)\n")
                    let localName = locality.replacingOccurrences(of: "市", with: "")
                    ConfigInfo.CITY = localName
                }
                if let subLocality = p.subLocality {
                    address.append("区划：\(subLocality)\n")
                }
            } else {
                print("No placemarks!")
            }
        })
    }
    
    /************************************** 天气 ***********************************/
    //    CLEAR_DAY：晴天
    //    CLEAR_NIGHT：晴夜
    //    PARTLY_CLOUDY_DAY：多云
    //    PARTLY_CLOUDY_NIGHT：多云
    //    CLOUDY：阴
    //    RAIN： 雨
    //    SNOW：雪
    //    WIND：风
    //    FOG：雾
    ///处理天气概况中英文互转
    func conversionEng2Ch(text: String) -> String {
        var cnText = ""
        if text == "CLEAR_DAY" || text == "CLEAR_NIGHT"  {
            cnText = "晴"
        } else if text == "PARTLY_CLOUDY_DAY" || text == "PARTLY_CLOUDY_NIGHT" {
            cnText = "云"
        } else if text == "CLOUDY" {
            cnText = "阴"
        } else if text == "RAIN" {
            cnText = "雨"
        } else if text == "SNOW" {
            cnText = "雪"
        } else if text == "WIND" {
            cnText = "风"
        } else if text == "FOG" || text == "HAZE" {
            cnText = "雾"
        } else {
            cnText = "迷"
        }
        return cnText
    }
}

/******************************** 时间 ********************************/
/// 获取当前时间
func getNowTime() -> String {
    // 获取当前时间
    let now = Date()
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "YYYY-MM-dd"
    // 返回当前时间
    return dformatter.string(from: now)
}
