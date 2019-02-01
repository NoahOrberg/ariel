//
//  ViewController.swift
//  ariel
//
//  Created by Noah Orberg on 2019/02/01.
//  Copyright © 2019 NoahOrberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var fairy: UIImageView!
    var cnt: NSInteger = 0
    var rFairy01: UIImage? // respiration
    var rFairy02: UIImage? // respiration
    var rFairy03: UIImage? // respiration
    var fairyRespiration:Array<UIImage?> = []
    var respirationTimer: Timer?
    var respirationInterval: Double = 0.5
    
    var gFairy01: UIImage? // glad
    var gFairy02: UIImage? // glad
    var fairyGlad:Array<UIImage?> = []
    var gladCnt: NSInteger = -1 // NOTE: it is not 0 coz if it's 0, start gald motion.
    
    var scWidth: NSInteger = 0
    var scHeight: NSInteger = 0
    
    var accWidth: NSInteger = 1
    var accHeight: NSInteger = 1
    var gap: NSInteger = 50
    var movingTimer: Timer?
    var movingSwitchTimer: Timer?
    var isMoving: NSInteger = -1 // NOTE: it is not 0 coz if it's 0, start moving.
    
    var crrFairyX: NSInteger = 200 // gap < x < height - gap
    var crrFairyY: NSInteger = 200 // gap < y < height - gap
    let ACC: NSInteger = 2
    var movingDirection: Bool = false // false is -ACC, true is ACC
    var movingTime: NSInteger = 30 // NOTE: it means, moving time. movingInterval * this
    var movingInterval: Double = 0.1
    var movingSwitchInterval: Double = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // NOTE: to Cheat BG color
        view.backgroundColor = UIColor.black
        
        // NOTE: check window size
        scWidth = NSInteger( UIScreen.main.bounds.size.width)
        scHeight = NSInteger( UIScreen.main.bounds.size.height)
        NSLog("%d x %d", scHeight, scWidth)
        
        // enable to handle tap event
        fairy.isUserInteractionEnabled = true
        fairy.contentMode = UIView.ContentMode.center
        crrFairyX = scWidth / 2
        crrFairyY = scHeight / 2
        
        let tapGlad:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.glad(_:)))
        fairy.addGestureRecognizer(tapGlad)
        
        rFairy01 = UIImage(named: "fairy01.png")
        rFairy02 = UIImage(named: "fairy02.png")
        rFairy03 = UIImage(named: "fairy03.png")
        gFairy01 = UIImage(named: "gFairy01.png")
        gFairy02 = UIImage(named: "gFairy02.png")
        fairyRespiration = [rFairy01, rFairy02, rFairy03, rFairy02]
        fairyGlad = [gFairy01, gFairy02]
        
        fairy.image = rFairy01
        fairy?.layer.position = CGPoint(x: crrFairyX, y: crrFairyY)
        
        // NOTE: respiration fairy
        respiration()
        
        // NOTE: moving
        moving()
        movingSwitch()
    }
    
    func respiration() {
        respirationTimer = Timer.scheduledTimer(timeInterval: respirationInterval, target: self, selector: #selector(ViewController.respirationUpdate), userInfo: nil, repeats: true)
    }
    
    func moving() {
        movingTimer = Timer.scheduledTimer(timeInterval: movingInterval, target: self, selector: #selector(ViewController.movingUpdate), userInfo: nil, repeats: true)
    }
    
    func movingSwitch() {
        movingSwitchTimer = Timer.scheduledTimer(timeInterval: movingSwitchInterval, target: self, selector: #selector(ViewController.movingSwitchUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func respirationUpdate() {
        fairy.isUserInteractionEnabled = !(gladCnt >= 0) // NOTE: avoid tap event while glad motion
        if (gladCnt >= 0) {
            fairy.image = fairyGlad[gladCnt]
            gladCnt+=1
            if (gladCnt == fairyGlad.count){
                gladCnt = -1 // NOTE: end glad motion
            }
        } else {
            fairy.image = fairyRespiration[cnt%self.fairyRespiration.count]
        }
        
        cnt+=1
        if (cnt == NSIntegerMax) { // NOTE: avoid overflow
            cnt = 0
        }
    }
    
    @objc func movingUpdate() {
        if (isMoving != -1){
            crrFairyX += movingDirection ? ACC : ACC * -1
            fairy?.layer.position = CGPoint(x: crrFairyX, y: crrFairyY)
        }
        if (isMoving == movingTime || isMoving == -1) {
            isMoving = -1
        } else {
            isMoving+=1
        }
        // NSLog("%d", isMoving)
    }
    
    @objc func movingSwitchUpdate() {
        isMoving = 0
        movingDirection = !movingDirection // NOTE: switch derection
    }

    @objc func glad(_ sender:UITapGestureRecognizer){
        gladCnt = 0
    }

}

