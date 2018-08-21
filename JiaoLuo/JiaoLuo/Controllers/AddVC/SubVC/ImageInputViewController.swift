//
//  ImageViewController.swift
//  JiaoLuo
//
//  Created by brooks on 2018/8/21.
//  Copyright © 2018年 brooks. All rights reserved.
//

import UIKit
import CLImagePickerTool

class ImageInputViewController: UIViewController {
    
    weak var turnPageDelegate: PageTurnDelegate!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = CLImagePickersTool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imagePicker.singleImageChooseType = .singlePicture
        imagePicker.isHiddenVideo = true
//        imagePicker.singleModelImageCanEditor = true
        imagePicker.cameraOut = true
        
        imagePicker.setupImagePickerWith(MaxImagesCount: 6, superVC: self) { (asset,cutImage) in
            
//            if asset.count > 1 {
////                let imageArr = CLImagePickersTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.2, successClouse: { iamge , asset in
////
////                }, failedClouse: {
////                    mLog(message: "失败" )
////                })
//            } else {
//
//            }
            let insets = UIEdgeInsetsMake(((cutImage?.size.height)! / 2) - 0.5, ((cutImage?.size.width)! / 2) - 0.5, ((cutImage?.size.height)! / 2) - 0.5, ((cutImage?.size.width)! / 2) - 0.5)
            self.imageView.image = cutImage
            self.imageView.image = self.imageView.image?.resizableImage(withCapInsets: insets, resizingMode: .tile)
            
        }
        
    }



}
