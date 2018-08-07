//
//  FeedsViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/7/31.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class FeedsViewController: UIViewController {
    
    // 标签栏变量
    @IBOutlet weak var labelBgScrollView: UIScrollView!
    let titles = ["全部", "文字", "声音", "照片", "视频", "打卡", "Todo"]
    var titleButtons: [UIButton] = []
    var titleLine: UIView!
    
    // Rx
    let disposeBag = DisposeBag()
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
    }
    
    func initConfig() {
        setupLabelsUI()
        DataProcesser().setLocation(self)
    }
    
    // MARK: - UI设置
    /// 设置标签栏
    func setupLabelsUI() {
        let titleWidth = view.width / 7
        var titleX = 0
        for i in titles.indices {
            let titleButton = UIButton(frame: CGRect(x: titleX, y: 2, width: Int(titleWidth), height: 22))
            titleX = Int(titleWidth * CGFloat(i + 1))
            titleButton.setTitle(titles[i], for: .normal)
            titleButton.tag = i
            titleButton.titleLabel?.textAlignment = .center
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            titleButton.setTitleColor(UIColor.ColorHex(hex: "888888"), for: .normal)
            titleButton.setTitleColor(UIColor.black, for: .selected)
            titleButtons.append(titleButton)
            labelBgScrollView.addSubview(titleButton)
            
            // 添加 Rx 方法
            titleButton.rx.tap
                .bind { [weak self] in
                    for i in (self?.titleButtons.indices)! {
                        if i != titleButton.tag {
                            self?.titleButtons[i].isSelected = false
                            self?.titleButtons[i].titleLabel?.font = UIFont.systemFont(ofSize: 18)
                        } else {
                            self?.titleButtons[i].isSelected = true
                            self?.titleButtons[i].titleLabel?.font = UIFont.systemFont(ofSize: 20)
                            // 移动效果
                            UIView.animate(withDuration: 0.2, animations: {
                                self?.titleLine.center.x = (self?.titleButtons[i].center.x)!
                            })
                        }
                    }
            }
            .disposed(by: disposeBag)
            
        }
        
        // 默认 【全部】
        titleButtons.first?.isSelected = true
        titleButtons.first?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        // 设置标签下划线
        titleLine = UIView(frame: CGRect(x: 0, y: (titleButtons.first?.bottom)! + 4, width: titleWidth - 10, height: 1))
        titleLine.backgroundColor = UIColor.black
        titleLine.center.x = (titleButtons.first?.center.x)!
        labelBgScrollView.addSubview(titleLine)
    }

}




extension FeedsViewController: CLLocationManagerDelegate {
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        ConfigInfo.LONGITUDE = currLocation.coordinate.longitude.description
        ConfigInfo.LAITUDE = currLocation.coordinate.latitude.description
        mLog(message: "经度：\(currLocation.coordinate.longitude)")
        mLog(message: "纬度：\(currLocation.coordinate.latitude)")
    }
}

