//
//  NumberSlideVC.swift
//  NumberSlide
//
//  Created by Phil Stern on 5/19/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//
//  click.wav obtained from: https://fresound.org/people/kwahmah_02/sounds/256116
//

import UIKit
import AVFoundation

class NumberSlideVC: UIViewController {
    
    private var game = NumberSlide()
    private var tileViews = [Int:TileView]()
    private var player: AVAudioPlayer?

    private var tileGap = 2.0
    private var borderWidth = 0.0  // computed in viewDidLayoutSubviews
    private var tileWidth = 0.0
    private var tileHeight = 0.0
    
    @IBOutlet weak var boardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTileViews()
    }
    
    override func viewDidLayoutSubviews() {  // bounds are set
        super.viewDidLayoutSubviews()
    
        borderWidth = 0.04 * Double(boardView.bounds.width)
        tileWidth = (Double(boardView.bounds.width) - borderWidth * 2.0 - tileGap * 3.0) / 4.0
        tileHeight = (Double(boardView.bounds.height) - borderWidth * 2.0 - tileGap * 3.0) / 4.0

        setTileViewPositions()
        checkIfPuzzleSolved()  // check, just in case
    }
    
    private func createTileViews() {
        for tile in game.tiles {
            let tileView = TileView()
            
            tileView.text = String(tile.identifier)
            
            if tile.identifier % 2 == 0 {
                tileView.backgroundColor = .red
            } else {
                tileView.backgroundColor = .white
            }
            
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
            
            tileViews[tile.identifier] = tileView
            
            // add tileViews to boardView
            boardView.addSubview(tileView)
        }
    }
    
    private func setTileViewPositions() {
        for row in 0...3 {
            for col in 0...3 {
                if let tile = game.board[row][col] {
                    let tileView = tileViews[tile.identifier]!
                    let frame = CGRect(x: (tileWidth + tileGap) * Double(col) + borderWidth,
                                       y: (tileHeight + tileGap) * Double(row) + borderWidth,
                                       width: tileWidth,
                                       height: tileHeight)
                    tileView.frame = frame
                }
            }
        }
    }
    
    @objc private func tileSwiped(recognizer: UISwipeGestureRecognizer) {
        if let tileView = recognizer.view {
            
            // compute row and col of swiped tile (inverse of frame equations above)
            let row = Int(round((Double(tileView.frame.origin.y) - borderWidth) / (tileHeight + tileGap)))
            let col = Int(round((Double(tileView.frame.origin.x) - borderWidth) / (tileWidth + tileGap)))
            
            if game.didMoveTileFrom(row: row, col: col, to: recognizer.direction) {
                UIView.transition(with: boardView,
                                  duration: 0.2,
                                  options: [],
                                  animations: { self.setTileViewPositions() },
                                  completion: { position in
                                    self.playClickSound()
                                    self.checkIfPuzzleSolved() }
                )
            }
        }
    }
    
    func checkIfPuzzleSolved() {
        var solved = true
        var tileCount = 1
        for row in 0...3 {
            for col in 0...3 {
                if let tile = game.board[row][col] {
                    if tile.identifier != tileCount { solved = false }
                    tileCount += 1
                } else {
                    if row + col != 6 { solved = false }  // blank space must be last
                }
            }
        }
        if solved {
            view.backgroundColor = .blue
        } else {
            view.backgroundColor = .lightGray
        }
    }
    
    func playClickSound() {
        guard let url = Bundle.main.url(forResource: "click", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            guard let player = player else { return }
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // mix tiles when iPhone is shaken
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            game.mixTiles()
            UIView.transition(with: boardView,
                              duration: 0.3,
                              options: [],
                              animations: { self.setTileViewPositions() },
                              completion: { position in
                                self.checkIfPuzzleSolved() }
            )
        }
    }
}

