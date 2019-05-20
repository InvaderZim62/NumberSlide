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
    private var tileGap = 2.0
    private var borderWidth = 0.0  // computed in viewDidLoad
    private var tileWidth = 0.0
    private var tileHeight = 0.0
    
    @IBOutlet weak var boardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        borderWidth = 0.04 * Double(boardView.bounds.width)
        tileWidth = (Double(boardView.bounds.width) - borderWidth * 2.0 - tileGap * 3.0) / 4.0
        tileHeight = (Double(boardView.bounds.height) - borderWidth * 2.0 - tileGap * 3.0) / 4.0

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
                    
                    // add swipe recognizers to tileView
                    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(tileSwiped))
                    swipeLeft.direction = .left
                    tileView.addGestureRecognizer(swipeLeft)
                    
                    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(tileSwiped))
                    swipeRight.direction = .right
                    tileView.addGestureRecognizer(swipeRight)
                    
                    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(tileSwiped))
                    swipeUp.direction = .up
                    tileView.addGestureRecognizer(swipeUp)
                    
                    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(tileSwiped))
                    swipeDown.direction = .down
                    tileView.addGestureRecognizer(swipeDown)
                    
                    boardView.addSubview(tileView)
                }
            }
        }
    }
    
    @objc private func tileSwiped(recognizer: UISwipeGestureRecognizer) {
        let tileView = recognizer.view
        let row = Int(round((Double(tileView!.frame.origin.y) - borderWidth) / (tileHeight + tileGap)))
        let col = Int(round((Double(tileView!.frame.origin.x) - borderWidth) / (tileWidth + tileGap)))

        if numberSlide.didMoveTileFrom(row: row, col: col, to: recognizer.direction) {
            switch recognizer.direction {
            case .left:
                tileView?.frame.origin.x = CGFloat((tileWidth + tileGap) * Double(col-1) + borderWidth)
                tileView?.frame.origin.y = CGFloat((tileHeight + tileGap) * Double(row) + borderWidth)
            case .right:
                tileView?.frame.origin.x = CGFloat((tileWidth + tileGap) * Double(col+1) + borderWidth)
                tileView?.frame.origin.y = CGFloat((tileHeight + tileGap) * Double(row) + borderWidth)
            case .up:
                tileView?.frame.origin.x = CGFloat((tileWidth + tileGap) * Double(col) + borderWidth)
                tileView?.frame.origin.y = CGFloat((tileHeight + tileGap) * Double(row-1) + borderWidth)
            case .down:
                tileView?.frame.origin.x = CGFloat((tileWidth + tileGap) * Double(col) + borderWidth)
                tileView?.frame.origin.y = CGFloat((tileHeight + tileGap) * Double(row+1) + borderWidth)
            default:
                print("(NumberSlideVC.tileSwiped) unknown swipe direction")
            }
        }
    }
}

