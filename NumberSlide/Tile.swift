//
//  Tile.swift
//  NumberSlide
//
//  Created by Phil Stern on 5/19/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import Foundation

class Tile: Codable {  // Codable, so it can be saved in UserDefaults
    
    var identifier: Int
    
    private static var identifierCount = 0
    
    init() {
        self.identifier = Tile.getUniqueIdentifier()
    }

    private static func getUniqueIdentifier() -> Int {
        identifierCount += 1
        return identifierCount
    }
}
