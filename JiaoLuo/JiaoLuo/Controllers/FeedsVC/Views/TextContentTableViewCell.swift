//
//  TextContentTableViewCell.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/9.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit

class TextContentTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var subInfoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 圆角和阴影
        bgView.layer.backgroundColor = UIColor.white.cgColor
        bgView.layer.borderWidth = 0.4
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.cornerRadius = 4
        bgView.layer.masksToBounds = false
        bgView.layer.contentsScale = UIScreen.main.scale
//        bgView.layer.shadowOpacity = 0.8
//        bgView.layer.shadowColor = UIColor.ColorHex(hex: "e0e0e0").cgColor
//        bgView.layer.shadowRadius = 4
//        bgView.layer.shadowOffset = CGSize(width: -2, height: 6)
        
//        let rect = CGRect(x: 8, y: 4, width: UIScreen.main.bounds.width - 16, height: bgView.height - 8)
//        bgView.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 4).cgPath
//        bgView.layer.shouldRasterize = true
//        bgView.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
