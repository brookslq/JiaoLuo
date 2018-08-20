//
//  LimitProcesser.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/2.
//  Copyright © 2018年 brooks. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LimitProcesser {

    static let limitProcesser = LimitProcesser()
    
    /// 提醒用户开启权限
    func askUser2Set(target: UIViewController, title: String, message: String, isAction: Bool = true) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let tempAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        var callAction: UIAlertAction!
        if isAction {
            callAction = UIAlertAction(title: "立即设置", style: .default) {
                action in
                let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
                if(UIApplication.shared.canOpenURL(url! as URL)) {
                    UIApplication.shared.open(url! as URL, options: ["":""], completionHandler: nil)
                }
            }
        } else {
            callAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        }
        alert.addAction(tempAction)
        alert.addAction(callAction)
        target.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - 定位
extension LimitProcesser {
    /// 检测定位权限
    func checkLoactionUsed() -> Bool {
        var isUsed: Bool!
        if CLLocationManager.authorizationStatus() != .denied {
            mLog(message: "用户有定位权限")
            isUsed = true
        } else {
            mLog(message: "用户无定位权限")
            isUsed = false
        }
        return isUsed
    }
    
}

