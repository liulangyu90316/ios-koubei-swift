//
//  TradeCollectionViewCell.swift
//  koubei
//
//  Created by michael on 14-7-1.
//  Copyright (c) 2014年 michael. All rights reserved.
//

import UIKit

class TradeCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel
    
    init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
//        println(self.titleLabel)
    }
}
