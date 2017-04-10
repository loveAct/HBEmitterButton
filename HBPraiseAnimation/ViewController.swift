//
//  ViewController.swift
//  HBPraiseAnimation
//
//  Created by apple on 2017/4/9.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var hbGoodBbtn: HBEmitterButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hbGoodBbtn.blingImage = #imageLiteral(resourceName: "idle")
        hbGoodBbtn.emit(count: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

