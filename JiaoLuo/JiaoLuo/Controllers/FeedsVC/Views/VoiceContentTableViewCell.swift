//
//  VoiceContentTableViewCell.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/21.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit

class VoiceContentTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var voiceButton: UIButton!
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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
