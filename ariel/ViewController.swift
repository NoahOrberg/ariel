//
//  ViewController.swift
//  ariel
//
//  Created by Noah Orberg on 2019/02/01.
//  Copyright © 2019 NoahOrberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ariel = ArielViewModel()
    
    var movingTimer: Timer?
    var movingSwitchTimer: Timer?

    var respirationTimer: Timer?
    var respirationInterval = 0.5

    var movingInterval = 0.1
    var movingSwitchInterval = 5.0

    override func loadView() {
        self.view = ArielView(ariel: ariel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // NOTE: to Cheat BG color (fairy bg is black... not transparent)
        view.backgroundColor = UIColor.black
        
        respiration()
        moving()
        NSLog("finished viewDidLoad")
    }

    func respiration() {
        let arielView = self.view as! ArielView
        respirationTimer = Timer.scheduledTimer(timeInterval: respirationInterval, target: arielView, selector: #selector(arielView.respirationUpdate), userInfo: nil, repeats: true)
    }
    
    func moving() {
        let arielView = self.view as! ArielView
        movingTimer = Timer.scheduledTimer(timeInterval: movingInterval, target: arielView, selector: #selector(arielView.movingUpdate), userInfo: nil, repeats: true)
        movingSwitch() // NOTE: to switch moving
    }

    func movingSwitch() {
        let arielView = self.view as! ArielView
        movingSwitchTimer = Timer.scheduledTimer(timeInterval: movingSwitchInterval, target: arielView, selector: #selector(arielView.movingSwitchUpdate), userInfo: nil, repeats: true)
    }

}

