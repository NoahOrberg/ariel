//
//  fukidashiModel.swift
//  ariel
//
//  Created by Noah Orberg on 2019/02/04.
//  Copyright © 2019 NoahOrberg. All rights reserved.
//

import Foundation
import UIKit

class FukidashiViewModel: NSObject {
    var fukidashiImage: UIImage?
    var commentWithFukidashiLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 35, width: 80, height: 17))
    
    override init() {
        super.init()
        fukidashiImage = UIImage(named: "fukidashi.png")
        
        // NOTE: fukidashi comment
        commentWithFukidashiLabel.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        commentWithFukidashiLabel.textAlignment = NSTextAlignment.center
        commentWithFukidashiLabel.adjustsFontSizeToFitWidth = true
        
        NSLog("initialized FukidashiViewModel")
    }
    
    func x(arielX: NSInteger) -> NSInteger {
        return arielX - 30
    }
    func y(arielY: NSInteger) -> NSInteger {
        return arielY - 70
    }
}
