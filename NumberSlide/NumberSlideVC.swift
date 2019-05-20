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

        let tileGap = 2.0
        let borderWidth = 0.04 * Double(boardView.bounds.width)
        let tileWidth = (Double(boardView.bounds.width) - borderWidth * 2.0 - tileGap * 3.0) / 4.0
        let tileHeight = (Double(boardView.bounds.height) - borderWidth * 2.0 - tileGap * 3.0) / 4.0

        for row in 0...3 {
            for col in 0...3 {
                let frame = CGRect(x: (tileWidth + tileGap) * Double(col) + borderWidth,
                                   y: (tileHeight + tileGap) * Double(row) + borderWidth,
                                   width: tileWidth,
                                   height: tileHeight)
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

