//
//  NumberSlideVC.swift
//  NumberSlide
//
//  Created by Phil Stern on 5/19/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//
//  click.wav obtained from: https://fresound.org/people/kwahmah_02/sounds/256116
//  tada.wav obtained from: https://fresound.org/people/jimhancock/sounds/376318
//  both files are in the public domain (CC0 1.0 Universal)
//

import UIKit
import AVFoundation

class NumberSlideVC: UIViewController, AVAudioPlayerDelegate {
    
    private var game = NumberSlide()
    private var tileViews = [Int:TileView]()
    private var player: AVAudioPlayer?

    private var tileGap = 2.0
    private var borderWidth = 0.0  // computed in viewDidLayoutSubviews
    private var tileWidth = 0.0
    private var tileHeight = 0.0
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAgainButton.isHidden = true
        game.restore()
        createTileViews()
    }
    
    // initially called after viewDidLoad and when bounds change
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        borderWidth = 0.04 * Double(boardView.bounds.width)
        tileWidth = (Double(boardView.bounds.width) - borderWidth * 2.0 - tileGap * 3.0) / 4.0
        tileHeight = (Double(boardView.bounds.height) - borderWidth * 2.0 - tileGap * 3.0) / 4.0

        setTileViewPositions()
        checkIfPuzzleSolved()
    }
    
    private func createTileViews() {
        for tile in game.tiles {
            let tileView = TileView()
            
            tileView.text = String(tile.identifier)
            
            if tile.identifier % 2 == 0 {
                tileView.backgroundColor = .red  // even numbered tile are red
            } else {
                tileView.backgroundColor = .white  // odd numbered tiles are white
            }
            
            // add four swipe gestures to tileView
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
            
            if game.moveTileFrom(row: row, col: col, to: recognizer.direction) {
                // animate moving the swiped tile(s)
                UIView.transition(with: boardView,
                                  duration: 0.1,
                                  options: [],
                                  animations: { self.setTileViewPositions() },
                                  completion: { position in
                                    self.playClickSound()
                                    self.checkIfPuzzleSolved() }
                )
                game.save()
            }
        }
    }
    
    func checkIfPuzzleSolved() {
        if game.isPuzzleSolved() {
            playTaDaSound()
        } else {
            playAgainButton.isHidden = true
        }
    }
    
    // wait until TaDa sound finishes, before showing "Play Again" button
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playAgainButton.isHidden = false
    }

    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        game.mixTiles()
        game.save()
        UIView.transition(with: boardView,
                          duration: 0.3,
                          options: [],
                          animations: { self.setTileViewPositions() },
                          completion: { position in
                            self.checkIfPuzzleSolved() }
        )
    }
    
    // call "Play Again" when iPhone shaken
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            playAgainButton.sendActions(for: .touchUpInside)
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
    
    func playTaDaSound() {
        guard let url = Bundle.main.url(forResource: "tada", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            guard let player = player else { return }
            player.delegate = self  // to receive call to audioPlayerDidFinishPlaying
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

