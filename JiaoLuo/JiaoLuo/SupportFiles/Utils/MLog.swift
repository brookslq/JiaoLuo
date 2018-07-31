//
//  MLog.swift
//
//  Created by brooks on 2018/3/15.
//  Copyright © 2018年 brooks. All rights reserved.
//

import Foundation

/* Build Settings -> Other Swift Flags -> Debug -> 添加"-D MLOG"
   定义 mLog 方法，在 Debug 时候打印输出信息
   默认填写 【文件名】、【函数名】、【行数】
   message 参数是一个泛型
*/

func mLog<T>(message: T, file: String = #file, funcName: String = #function,
             lineNum: Int = #line) {
    #if MLOG
    let fileName = (file as NSString).lastPathComponent
        print("""
            \(fileName) --> \(funcName)
            第\(lineNum)行： \(message) \n
            """)
    #endif
}

// 获取文件名
func getFileName(file: String = #file) -> String {
    var fileName = (file as NSString).lastPathComponent
    fileName = fileName.replacingOccurrences(of: ".swift", with: "")
    return fileName
}

