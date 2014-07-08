//
//  Locale.swift
//  koubei
//
//  Created by michael on 14-7-7.
//  Copyright (c) 2014 michael. All rights reserved.
//

import UIKit

class Locale: NSObject {
    
    // simple handle
    class func getLocaleCH() -> NSDictionary {
        var Lang_CH = [
            "COMT": "评论",
            "GOOD_COMT": "好评",
            "WANNA_COMT": "我要评论"
        ];
        
        return Lang_CH
    }
}
