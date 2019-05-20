//
//  TileView.swift
//  NumberSlide
//
//  Created by Phil Stern on 5/19/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class TileView: UIView {
    
    var text = ""
    let fontSize = CGFloat(60.0)
    
    override func draw(_ rect: CGRect) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.brown,
        ]

        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        let stringRect = CGRect(x: 0, y: (self.bounds.height - 1.2*fontSize)/2,
                                width: self.bounds.width, height: self.bounds.height)
        attributedString.draw(in: stringRect)
    }
}
