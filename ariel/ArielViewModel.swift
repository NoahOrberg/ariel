//
//  AriemModel.swift
//  ariel
//
//  Created by Noah Orberg on 2019/02/04.
//  Copyright © 2019 NoahOrberg. All rights reserved.
//

import Foundation
import UIKit

class ArielViewModel: NSObject {
    var cnt: NSInteger = 0
    var movingTime: NSInteger = 25 // NOTE: it means, moving time. movingInterval * this

    var respImages:Array<UIImage?> = []
    
    var gladImages: Array<Array<UIImage?>> = []
    var gladMotionCnt: NSInteger = 0
    var gladCnt: NSInteger = -1 // NOTE: it is not 0 coz if it's 0, start glad motion.
    
    var scWidth: NSInteger = NSInteger( UIScreen.main.bounds.size.width)
    var scHeight: NSInteger = NSInteger( UIScreen.main.bounds.size.height)
    
    var gap: NSInteger = 100
    var isMoving: NSInteger = -1 // NOTE: it is not 0 coz if it's 0, start moving.
    
    var x: NSInteger = 200 // gap < x < height - gap
    var y: NSInteger = 200 // gap < y < height - gap
    let ACC: NSInteger = 2
    var movingDirection: NSInteger = 0 // this % 4: 0=right, 1=left, 2=down, 3=up
    var directionRange: ClosedRange<NSInteger> = 0 ... 3
    var movingTimeRange: ClosedRange<NSInteger> = 5...30
    
    let gladComment: Array<Array<String>> = [["ふええ..."], ["ふええ..."], ["シャボン玉〜"]]
    let respComments: Array<String> = ["暇だな〜", "眠いよ", "ここ暗い"]
    var respCommentsCnt: NSInteger = -1 // NOTE: this is used to show comment when respiration. it is not 0 coz if it's 0, start show comment
    let respCommentsMaxTime: NSInteger = 3 // NOTE: this is used to show comment when respiration. it is max time.
    let respCommentFreqRange: ClosedRange<NSInteger> = 1...15 // NOTE: freq for show comment when respiration. this value should be 1...X
    
    var fukidashiImage: UIImage?
    var commentWithFukidashiLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 35, width: 80, height: 17))
    
    override init() {
        super.init()
    
        respImages = [UIImage(named: "fairy01.png"), UIImage(named: "fairy02.png"), UIImage(named: "fairy03.png"), UIImage(named: "fairy02.png")]
        gladImages = [[UIImage(named: "gFairy01.png"), UIImage(named: "gFairy02.png")],
                     [UIImage(named: "gFairy01.png"), UIImage(named: "gFairy01.5.png"), UIImage(named: "gFairy02.png")],
                     [UIImage(named: "sFairy01.png"), UIImage(named: "sFairy02.png"), UIImage(named: "sFairy03.png")]]

        fukidashiImage = UIImage(named: "fukidashi.png")
        
        // NOTE: fukidashi comment
        commentWithFukidashiLabel.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        commentWithFukidashiLabel.textAlignment = .center
        commentWithFukidashiLabel.adjustsFontSizeToFitWidth = true
        
        
        x = scWidth / 2
        y = scHeight / 2
        NSLog("initialized ArielViewModel")
    }
    
    func fukidashiX(arielX: NSInteger) -> NSInteger {
        return arielX - 30
    }
    func fukidashiY(arielY: NSInteger) -> NSInteger {
        return arielY - 70
    }
    
}
