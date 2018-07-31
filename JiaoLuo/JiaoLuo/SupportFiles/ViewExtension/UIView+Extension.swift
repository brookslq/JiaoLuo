//
//  UIView+Extension.swift
//
//  Created by brooks on 2017/10/23.
//  Copyright © 2017年 brooks. All rights reserved.
//

import Foundation
import UIKit

//View 布局的扩展
extension UIView {
    //View的X值
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newVal
            frame                 = tmpFrame
        }
    }
    
    //View的Y值
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newVal
            frame                 = tmpFrame
        }
    }
    
    //中心点X值
    var midX : CGFloat{
        get {
            return self.bounds.width*0.5
        }
    }
    
    //中心点Y值
    var midY : CGFloat{
        get{
            return self.bounds.height*0.5
        }
    }
    //左间距
    var left: CGFloat{
        get{
            return self.frame.origin.x
        }
        
        set(value){
            var rect = self.frame
            rect.origin.x = value
            self.frame    = rect
        }
    }
    
    //右间距
    var right: CGFloat{
        get{
            return (self.frame.origin.x + self.frame.size.width)
        }
        
        set(value){
            var rect      = self.frame
            rect.origin.x = (value - self.frame.size.width)
        }
    }
    
    //宽度
    var width: CGFloat{
        get {
            return self.bounds.width
        }
        
        set(myWidth){
            var rect        = self.frame
            rect.size.width = myWidth
            self.frame      = rect
        }
    }
    
    //顶部间距
    var top: CGFloat{
        get{
            return self.frame.origin.y
        }
        
        set(value){
            var rect      = self.frame
            rect.origin.y = value
            self.frame    = rect
        }
    }
    
    //底部间距
    var bottom: CGFloat{
        get{
            return (self.frame.origin.y + self.frame.size.height)
        }
        
        set(value){
            var rect      = self.frame
            rect.origin.y = (value - self.frame.size.height)
            self.frame    = rect
        }
    }
    
    //高度
    var height: CGFloat{
        get {
            return self.bounds.height
        }
        set(myHeight){
            var rect         = self.frame
            rect.size.height = myHeight
            self.frame       = rect
        }
    }
}

// MARK: - 判断是否为 iPhone X
extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}


