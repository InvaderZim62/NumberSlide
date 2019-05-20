//
//  NumberSlide.swift
//  NumberSlide
//
//  Created by Phil Stern on 5/19/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class NumberSlide {

    var tiles = [Tile]()
    var board = [[Tile]]()
    var isGameOver = false
    
    init() {
        for _ in 1...15 {
            let tile = Tile()
            tiles.append(tile)
        }
        mixTiles()
    }
    
    private func mixTiles() {
        for index in tiles.indices {
            let tempTile = tiles[index]
            let randomIndex = tiles.count.arc4random  // my extension, below
            tiles[index] = tiles[randomIndex]
            tiles[randomIndex] = tempTile
        }
    }
}

// extend int to return random number from 0 to the int itself
extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
