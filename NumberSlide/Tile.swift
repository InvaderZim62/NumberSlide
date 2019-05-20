//
//  Tile.swift
//  NumberSlide
//
//  Created by Phil Stern on 5/19/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class Tile {
    
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Tile.getUniqueIdentifier()
    }
}

extension Tile: Hashable {  // make hashable, so it can be used as a dictionary key
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
