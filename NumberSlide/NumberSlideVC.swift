//
//  NumberSlideVC.swift
//  NumberSlide
//
//  Created by Phil Stern on 5/19/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class NumberSlideVC: UIViewController {
    
    private var numberSlide = NumberSlide()

    @IBOutlet weak var tileView: TileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tileView.text = "3"
    }

}

