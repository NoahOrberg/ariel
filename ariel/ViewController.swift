//
//  ViewController.swift
//  ariel
//
//  Created by Noah Orberg on 2019/02/01.
//  Copyright © 2019 NoahOrberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ariel: ArielViewModel = ArielViewModel()
    var fukidashi: FukidashiViewModel = FukidashiViewModel()
    
    var movingTimer: Timer?
    var movingSwitchTimer: Timer?
    
    var respirationTimer: Timer?
    var respirationInterval: Double = 0.5
    
    var movingInterval: Double = 0.1
    var movingSwitchInterval: Double = 5.0
    
    var tapGlad: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func loadView() {
        self.view = ArielView(ariel: ariel, fukidashi: fukidashi)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // NOTE: to Cheat BG color (fairy bg is black... not transparent)
        view.backgroundColor = UIColor.black
        
        respiration()
        moving()
        movingSwitch()
        setupGladTapGesture()
        NSLog("finished viewDidLoad")
    }
    
    func setupGladTapGesture() {
        let arielView = self.view as! ArielView
        tapGlad = UITapGestureRecognizer(target: self, action: #selector(ViewController.glad))
        arielView.arielView.addGestureRecognizer(tapGlad)
        let superviews = chainIterator(arielView.arielView) { $0?.superview }
        superviews.forEach { print($0.isUserInteractionEnabled) }
        NSLog("setuped GladTapGesture")
    }
    
    func chainIterator<T>(_ value: T, _ f: @escaping (T?) -> (T?)) -> AnyIterator<T> {
        var next: T? = value
        return AnyIterator {
            defer { next = f(next) }
            return next
        }
    }

    func respiration() {
        respirationTimer = Timer.scheduledTimer(timeInterval: respirationInterval, target: self, selector: #selector(ViewController.respirationUpdate), userInfo: nil, repeats: true)
    }
    
    func moving() {
        movingTimer = Timer.scheduledTimer(timeInterval: movingInterval, target: self, selector: #selector(ViewController.movingUpdate), userInfo: nil, repeats: true)
        movingSwitch() // NOTE: to switch moving
    }

    func movingSwitch() {
        movingSwitchTimer = Timer.scheduledTimer(timeInterval: movingSwitchInterval, target: self, selector: #selector(ViewController.movingSwitchUpdate), userInfo: nil, repeats: true)
    }

    @objc func respirationUpdate() {
        let arielView = self.view as! ArielView
        arielView.arielView.isUserInteractionEnabled = !(ariel.gladCnt >= 0) // NOTE: avoid tap event while glad motion
        if (ariel.gladCnt >= 0) {
            arielView.arielView.image = ariel.gladImages[ariel.gladMotionCnt][ariel.gladCnt]
            ariel.gladCnt+=1
            if (ariel.gladCnt == ariel.gladImages[ariel.gladMotionCnt].count){
                ariel.gladCnt = -1 // NOTE: end glad motion
            }
        } else {
            arielView.arielView.image = ariel.respImages[ariel.cnt%ariel.respImages.count]
            if (!arielView.fukidashiView.isHidden && ariel.respCommentsCnt == -1) {
                arielView.fukidashiView.isHidden = true
            }
            if (Int.random(in: ariel.respCommentFreqRange) == 1 && ariel.respCommentsCnt == -1) {
                ariel.respCommentsCnt = 0 // NOTE: show comment when respiration, start
            }
        }
        if (ariel.respCommentsCnt >= 0) {
            arielView.fukidashiView.isHidden = false
            if (ariel.respCommentsCnt == 0) {
                fukidashi.commentWithFukidashiLabel.text = ariel.respComments[Int.random(in: 0...ariel.respComments.count-1)] // NOTE: show message is random
            }
            ariel.respCommentsCnt+=1
            if (ariel.respCommentsCnt >= ariel.respCommentsMaxTime) {
                // NOTE: post process for showing resp comments
                ariel.respCommentsCnt = -1
                arielView.fukidashiView.isHidden = true
            }
        }
        
        ariel.cnt+=1
        if (ariel.cnt == NSIntegerMax) { // NOTE: avoid overflow
            ariel.cnt = 0
        }
    }
    
    @objc func movingUpdate() {
        let arielView = self.view as! ArielView
        if (ariel.isMoving != -1){
            if (ariel.movingDirection < 2) { // NOTE: X or Y
                ariel.x += (ariel.movingDirection % 2 == 0) ? ariel.ACC : ariel.ACC * -1 // NOTE: right or left
            } else {
                ariel.y += (ariel.movingDirection % 2 == 0) ? ariel.ACC : ariel.ACC * -1 // NOTE: down or up
            }
            arielView.arielView.layer.position = CGPoint(x: ariel.x, y: ariel.y)
            // NOTE: with fukidashi
            arielView.fukidashiView.center = CGPoint(x:fukidashi.x(arielX: ariel.x), y:fukidashi.y(arielY: ariel.y))
        }
        if (ariel.isMoving == ariel.movingTime || ariel.isMoving == -1) {
            ariel.isMoving = -1
        } else {
            ariel.isMoving+=1
        }
        // NSLog("%d", isMoving)
    }
    
    @objc func movingSwitchUpdate() {
        ariel.isMoving = 0
        ariel.movingTime = Int.random(in: ariel.movingTimeRange) // NOTE: decide walking time by random
        repeat {
            ariel.movingDirection = Int.random(in: ariel.directionRange) // NOTE: switch derection
        } while (checkDirection())
    }
    
    func checkDirection() -> Bool {
        if (ariel.movingDirection == 0) {
            return (ariel.x + ariel.movingTime * ariel.ACC > ariel.scWidth - ariel.gap) // right
        }
        if (ariel.movingDirection == 1) {
            return (ariel.x - ariel.movingTime * ariel.ACC < ariel.gap) // left
        }
        if (ariel.movingDirection == 2) {
            return (ariel.y + ariel.movingTime * ariel.ACC > ariel.scHeight - ariel.gap) // down
        }
        if (ariel.movingDirection == 3) {
            return (ariel.y - ariel.movingTime * ariel.ACC < ariel.gap) // up
        }
        return false // NOTE: unreachable statement
    }

    @objc func glad(_ sender: UITapGestureRecognizer){
        NSLog("invoked glad()")
        ariel.gladCnt = 0
        ariel.gladMotionCnt = Int.random(in: 0...(ariel.gladImages.count-1))
        fukidashi.commentWithFukidashiLabel.text = ariel.gladComment[ariel.gladMotionCnt][Int.random(in: 0...(ariel.gladComment[ariel.gladMotionCnt].count)-1)]
        
        let arielView = self.view as! ArielView
        arielView.fukidashiView.isHidden = false
    }
}

