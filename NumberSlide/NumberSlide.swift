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
    var isGameOver = false
    
    init() {
        for _ in 1...15 {
            let tile = Tile()
            tiles.append(tile)
        }
    }
}
