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
import RealmSwift
class FeedsViewController: UIViewController {
    
    // 标签栏变量
    @IBOutlet weak var labelBgScrollView: UIScrollView!
//    ["文字", "声音", "照片", "视频", "打卡", "TODO"]
    let titles = ["文字", "声音", "照片", "视频"]
    var titleButtons: [UIButton] = []
    var titleLine: UIView!
    var selectedTitleTag = 0    // 默认是首位
    
    var realmDB: Realm!
    
    // 内容
    var scrollerV: UIScrollView!
    var lastContentOffset: CGFloat = 0
    
    
    var textTableView: TextTableView!
    
    // Rx
    let disposeBag = DisposeBag()
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
        realmDB = RealmManager.default.createDB(ConfigInfo.JIAOLUO, isReadOnly: false)
        mLog(message: realmDB)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard realmDB != nil else {
            return
        }
        mLog(message: realmDB.objects(TextContentModel.self))
        guard textTableView != nil else {
            return
        }
        // 对结果根据 属性 进行了降序排列
        textTableView.textModels = realmDB.objects(TextContentModel.self).sorted(byKeyPath: "originTime", ascending: false)
        textTableView.reloadData()
    }
    
    func initConfig() {
        setupLabelsUI()
        DataProcesser.default.setLocation(self)
        setupTableView()
    }
    
    // MARK: - UI设置
    /// tableview设置
    func setupTableView() {
        let countSeg = titles.count
        scrollerV = UIScrollView.init(frame: CGRect(x: 0, y: 120, width: view.width , height: view.frame.height - 120))
        scrollerV.contentSize = CGSize(width: view.frame.width * CGFloat(countSeg), height: view.frame.height - 120 )
        scrollerV.tag = 1
        scrollerV.isPagingEnabled = true
        scrollerV.delegate = self
        scrollerV.showsHorizontalScrollIndicator = false
        scrollerV.bounces = false
        scrollerV.isScrollEnabled = false
        self.view.addSubview(scrollerV)
        
        textTableView = TextTableView(frame: CGRect(x: 0, y: 0, width: view.width, height: scrollerV.height), style: .plain)
        textTableView.textTVDelegate = self
        scrollerV.addSubview(textTableView)
    }
    
    /// 设置标签栏
    func setupLabelsUI() {
        // 去除下方黑线
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        labelBgScrollView.backgroundColor = UIColor.white
        
        let titleWidth = view.width / CGFloat(titles.count)
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
                            self?.selectedTitleTag = i
                            // 底部线 移动效果
                            UIView.animate(withDuration: 0.2, animations: {
                                self?.titleLine.center.x = (self?.titleButtons[i].center.x)!
                            })
                            // scrollerView 移动
                            self?.scrollerV.setContentOffset(CGPoint(x: (self?.view.width)! * CGFloat(i), y: 0), animated: true)
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
    
    // 更改标签栏选中及进行相应的动画效果
    func selectedTitleChangeEvent(_ selectedIndex: Int, current index: Int) {
        titleButtons[selectedTitleTag].isSelected = false
        titleButtons[selectedTitleTag].titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        titleButtons[index].isSelected = true
        titleButtons[index].titleLabel?.font = UIFont.systemFont(ofSize: 20)
        selectedTitleTag = index
        
        // 底部线 移动效果
        UIView.animate(withDuration: 0.2, animations: {
            self.titleLine.center.x = (self.titleButtons[index].center.x)
        })
        // scrollerView 移动
        scrollerV.setContentOffset(CGPoint(x: view.width * CGFloat(index), y: 0), animated: true)
    }
}


extension FeedsViewController: UIScrollViewDelegate{
    
    func  scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let leftOrRight = scrollView.contentOffset.x
        //索引值需要约束，在自减得时候不能小于0，自加的时候不能大于数组长度
        //如果是边界值向无值区域滑动，需要禁止
        //判断左右滑动
        if leftOrRight > lastContentOffset{
            //向左滑动
            if selectedTitleTag < titles.count {
                selectedTitleChangeEvent(selectedTitleTag, current: selectedTitleTag + 1)
            }
        }
        if leftOrRight < lastContentOffset{
            //向右滑动
            if selectedTitleTag > 0 {
                selectedTitleChangeEvent(selectedTitleTag, current: selectedTitleTag - 1)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.x
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

extension FeedsViewController: TextTableViewDelegate {
    func cellDidSelectedEvent(_ textModel: TextContentModel) {
        let textShowVC = TextShowViewController()
        textShowVC.textModel = textModel
        self.navigationController?.pushViewController(textShowVC, animated: true)
    }
    
    
}
