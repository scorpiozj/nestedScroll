//
//  Constants.swift
//  NestedScrollView
//
//  Created by ZhuJiang on 17/1/8.
//  Copyright © 2017年 Charles. All rights reserved.
//

import Foundation

struct ZZConstrants {
    
    static let Pull_Threshold = 60
    
    static let appName     = "Test"
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        static let Tmp = NSTemporaryDirectory()
    }
    
    
}
