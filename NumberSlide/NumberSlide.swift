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
    var puzzleSolved = false
    
    private var blankRow = 3
    private var blankCol = 3
    
    init() {
        // create tiles
        for _ in 1...15 {
            let tile = Tile()
            tiles.append(tile)
        }
        mixTiles()
    }
    
    // ramdomly change the order of the tiles array (verify it's solvable)
    func mixTiles() {
        puzzleSolved = false
        blankRow = 4.arc4random
        blankCol = 4.arc4random
        repeat {
            for index in tiles.indices {
                let tempTile = tiles[index]
                let randomIndex = tiles.count.arc4random  // my extension, below
                tiles[index] = tiles[randomIndex]
                tiles[randomIndex] = tempTile
            }
        } while !isSolvable()
        
        placeTilesOnBoard()
    }
    
    // Algorithm to determine if a 15 puzzle is solvable (from: http://mathworld.wolfram.com/15Puzzle.html)
    // If the inversion count is even, the puzzle is solvable.
    private func isSolvable() -> Bool {
        var inversionCount = blankRow + 1
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

    func placeTilesOnBoard() {
        board.removeAll()
        
        // place tiles on board, leaving last square blank
        var tileCount = 0
        for row in 0...3 {
            var tileRow = [Tile?]()
            for col in 0...3 {
                if (row == blankRow && col == blankCol) {
                    tileRow.append(nil)
                } else {
                    tileRow.append(tiles[tileCount])
                    tileCount += 1
                }
            }
            board.append(tileRow)  // append next row of three tiles
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
        checkIfPuzzleSolved()
        return tilesMoved
    }
    
    private func checkIfPuzzleSolved() {
        puzzleSolved = true
        var tileCount = 1
        for row in 0...3 {
            for col in 0...3 {
                if let tile = board[row][col] {
                    if tile.identifier != tileCount { puzzleSolved = false }
                    tileCount += 1
                } else {
                    if row + col != 6 { puzzleSolved = false }  // blank space must be last
                }
            }
        }
    }
}

// extend int to return random number from 0 to the int itself
extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
