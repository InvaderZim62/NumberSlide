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
    
    @IBOutlet weak var boardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for row in 0...3 {
            for col in 0...3 {
                let frame = CGRect(x: 82 * col + 14, y: 82 * row + 14, width: 80, height: 80)
                let tileView = TileView(frame: frame)
                if let tile = numberSlide.board[row][col] {
                    tileView.text = String(tile.identifier)
                    if tile.identifier % 2 == 0 {
                        tileView.backgroundColor = .red
                    } else {
                        tileView.backgroundColor = .white
                    }
                }
                boardView.addSubview(tileView)
            }
        }
    }
    
}

