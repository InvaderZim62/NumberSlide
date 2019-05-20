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
    var board = [[Tile?]]()
    var isGameOver = false
    
    init() {
        for _ in 1...15 {
            let tile = Tile()
            tiles.append(tile)
        }
        mixTiles()
        var count = 0
        for row in 0...3 {
            var tileRow = [Tile?]()
            for col in 0...3 {
                if (row == 3 && col == 3) {
                    tileRow.append(nil)
                } else {
                    tileRow.append(tiles[count])
                    count += 1
                }
            }
            board.append(tileRow)
        }
    }
    
    private func mixTiles() {
        for index in tiles.indices {
            let tempTile = tiles[index]
            let randomIndex = tiles.count.arc4random  // my extension, below
            tiles[index] = tiles[randomIndex]
            tiles[randomIndex] = tempTile
        }
    }
    
    func didMoveTileFrom(row: Int, col: Int, to direction: UISwipeGestureRecognizer.Direction) -> Bool {
        switch direction {
        case .left:
            if col > 0 && board[row][col-1] == nil {
                board[row][col-1] = board[row][col]
                board[row][col] = nil
                return true
            }
        case .right:
            if col < 3 && board[row][col+1] == nil {
                board[row][col+1] = board[row][col]
                board[row][col] = nil
                return true
            }
        case .up:
            if row > 0 && board[row-1][col] == nil {
                board[row-1][col] = board[row][col]
                board[row][col] = nil
                return true
            }
        case .down:
            if row < 3 && board[row+1][col] == nil {
                board[row+1][col] = board[row][col]
                board[row][col] = nil
                return true
            }
        default:
            print("(NumberSlide.didMoveTileFrom) unknown swipe direction")
        }
        return false
    }
}

// extend int to return random number from 0 to the int itself
extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
