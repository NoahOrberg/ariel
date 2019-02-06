//
//  CustomView.swift
//  ariel
//
//  Created by Noah Orberg on 2019/02/04.
//  Copyright © 2019 NoahOrberg. All rights reserved.
//

import UIKit

class ArielView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var fukidashiView: UIImageView!
    var arielView: UIImageView!
    
    var ariel: ArielViewModel = ArielViewModel()

    required init(ariel: ArielViewModel) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.ariel = ariel
        
        arielView = UIImageView(image: ariel.respImages[0])
        fukidashiView = UIImageView(image: ariel.fukidashiImage)

        fukidashiView.addSubview(ariel.commentWithFukidashiLabel)
        self.addSubview(arielView)
        self.addSubview(fukidashiView)
        
        NSLog("initialized ArielView")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    
        NSLog("invoked .layoutSubview()")

        arielView?.isUserInteractionEnabled = true // NOTE: enable to handle tap event
        arielView?.contentMode = UIView.ContentMode.center
        arielView?.contentMode = .scaleAspectFill
        arielView?.center = CGPoint(x:ariel.x, y:ariel.y)
        setupGladTapGesture()

        fukidashiView?.center = CGPoint(x:ariel.fukidashiX(arielX: ariel.x), y:ariel.fukidashiY(arielY: ariel.y))
        fukidashiView?.isHidden = true
    }

    func setupGladTapGesture() {
        let tapGlad = UITapGestureRecognizer(target: self, action: #selector(self.glad(_:)))
        self.arielView.addGestureRecognizer(tapGlad)
        NSLog("setuped GladTapGesture")
    }

    @objc func respirationUpdate() {
        self.arielView.isUserInteractionEnabled = !(ariel.gladCnt >= 0) // NOTE: avoid tap event while glad motion
        if (ariel.gladCnt >= 0) {
            self.arielView.image = ariel.gladImages[ariel.gladMotionCnt][ariel.gladCnt]
            ariel.gladCnt+=1
            if (ariel.gladCnt == ariel.gladImages[ariel.gladMotionCnt].count){
                ariel.gladCnt = -1 // NOTE: end glad motion
            }
        } else {
            self.arielView.image = ariel.respImages[ariel.cnt%ariel.respImages.count]
            if (!self.fukidashiView.isHidden && ariel.respCommentsCnt == -1) {
                self.fukidashiView.isHidden = true
            }
            if (Int.random(in: ariel.respCommentFreqRange) == 1 && ariel.respCommentsCnt == -1) {
                ariel.respCommentsCnt = 0 // NOTE: show comment when respiration, start
            }
        }
        if (ariel.respCommentsCnt >= 0) {
            self.fukidashiView.isHidden = false
            if (ariel.respCommentsCnt == 0) {
                ariel.commentWithFukidashiLabel.text = ariel.respComments[Int.random(in: 0...ariel.respComments.count-1)] // NOTE: show message is random
            }
            ariel.respCommentsCnt+=1
            if (ariel.respCommentsCnt >= ariel.respCommentsMaxTime) {
                // NOTE: post process for showing resp comments
                ariel.respCommentsCnt = -1
                self.fukidashiView.isHidden = true
            }
        }

        ariel.cnt+=1
        if (ariel.cnt == NSIntegerMax) { // NOTE: avoid overflow
            ariel.cnt = 0
        }
    }

    @objc func movingUpdate() {
        if (ariel.isMoving != -1){
            if (ariel.movingDirection < 2) { // NOTE: X or Y
                ariel.x += (ariel.movingDirection % 2 == 0) ? ariel.ACC : ariel.ACC * -1 // NOTE: right or left
            } else {
                ariel.y += (ariel.movingDirection % 2 == 0) ? ariel.ACC : ariel.ACC * -1 // NOTE: down or up
            }
            self.arielView.layer.position = CGPoint(x: ariel.x, y: ariel.y)
            // NOTE: with fukidashi
            self.fukidashiView.center = CGPoint(x:ariel.fukidashiX(arielX: ariel.x), y:ariel.fukidashiY(arielY: ariel.y))
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
        ariel.commentWithFukidashiLabel.text = ariel.gladComment[ariel.gladMotionCnt][Int.random(in: 0...(ariel.gladComment[ariel.gladMotionCnt].count)-1)]

        self.fukidashiView.isHidden = false
    }
}
