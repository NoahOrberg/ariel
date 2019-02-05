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
    
    required init(ariel: ArielViewModel, fukidashi: FukidashiViewModel) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        arielView = UIImageView(image: ariel.respImages[0])
        arielView?.isUserInteractionEnabled = true // NOTE: enable to handle tap event
        arielView?.contentMode = UIView.ContentMode.center
        arielView?.center = CGPoint(x:ariel.x, y:ariel.y)
        arielView?.contentMode = .scaleAspectFill
        
        fukidashiView = UIImageView(image: fukidashi.fukidashiImage)
        fukidashiView?.center = CGPoint(x:fukidashi.x(arielX: ariel.x), y:fukidashi.y(arielY: ariel.y))
        fukidashiView?.isHidden = true
        
        fukidashiView.addSubview(fukidashi.commentWithFukidashiLabel)
        self.addSubview(arielView)
        self.addSubview(fukidashiView)
        
        NSLog("initialized ArielView")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
