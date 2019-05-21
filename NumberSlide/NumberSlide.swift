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
        repeat {
            for index in tiles.indices {
                let tempTile = tiles[index]
                let randomIndex = tiles.count.arc4random  // my extension, below
                tiles[index] = tiles[randomIndex]
                tiles[randomIndex] = tempTile
            }
        } while !isSolvable()
    }
    
    //
    // Algorithm to determine if a 15 puzzle is solvable
    // from: http://mathworld.wolfram.com/15Puzzle.html
    //
    private func isSolvable() -> Bool {
        var inversionCount = 0
        for i in 0...13 {
            let num1 = tiles[i].identifier
            for j in (i + 1)...14 {
                let num2 = tiles[j].identifier
                if num2 < num1 { inversionCount += 1 }
            }
        }
        if inversionCount % 2 == 0 {
            return true
        } else {
            return false
        }
    }
    
    func didMoveTileFrom(row: Int, col: Int, to direction: UISwipeGestureRecognizer.Direction) -> Bool {
        var tilesMoved = false
        switch direction {
        case .left:
            if col > 0 && board[row][col-1] == nil {
                board[row][col-1] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            } else if col > 1 && board[row][col-2] == nil {
                board[row][col-2] = board[row][col-1]
                board[row][col-1] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            } else if col > 2 && board[row][col-3] == nil {
                board[row][col-3] = board[row][col-2]
                board[row][col-2] = board[row][col-1]
                board[row][col-1] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            }
        case .right:
            if col < 3 && board[row][col+1] == nil {
                board[row][col+1] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            } else if col < 2 && board[row][col+2] == nil {
                board[row][col+2] = board[row][col+1]
                board[row][col+1] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            } else if col < 1 && board[row][col+3] == nil {
                board[row][col+3] = board[row][col+2]
                board[row][col+2] = board[row][col+1]
                board[row][col+1] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            }
        case .up:
            if row > 0 && board[row-1][col] == nil {
                board[row-1][col] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            } else if row > 1 && board[row-2][col] == nil {
                board[row-2][col] = board[row-1][col]
                board[row-1][col] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            } else if row > 2 && board[row-3][col] == nil {
                board[row-3][col] = board[row-2][col]
                board[row-2][col] = board[row-1][col]
                board[row-1][col] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            }
        case .down:
            if row < 3 && board[row+1][col] == nil {
                board[row+1][col] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            } else if row < 2 && board[row+2][col] == nil {
                board[row+2][col] = board[row+1][col]
                board[row+1][col] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            } else if row < 1 && board[row+3][col] == nil {
                board[row+3][col] = board[row+2][col]
                board[row+2][col] = board[row+1][col]
                board[row+1][col] = board[row][col]
                board[row][col] = nil
                tilesMoved = true
            }
        default:
            print("(NumberSlide.didMoveTileFrom) unknown swipe direction")
        }
        return tilesMoved
    }
}

// extend int to return random number from 0 to the int itself
extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
