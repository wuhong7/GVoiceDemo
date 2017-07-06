//
//  WHUtil.swift
//  getbrowser
//
//  Created by 黄喜明 on 2017/5/9.
//  Copyright © 2017年 Get Technology. All rights reserved.
//

import UIKit

//适配系数
let adaptRatio = UIScreen.main.bounds.size.height/667
let adaptRatioW = UIScreen.main.bounds.size.width/375

func PrintLog<T>(message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    #if DebugType
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

class WHUtil {
    
}
