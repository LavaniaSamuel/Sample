//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Samuel Lavania on 16/5/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import Foundation

struct FacialExpression {
    
    enum Eyes: Int {
        case open
        case close
        case squint
    }
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile

        var sadder: Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        
        var happier: Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    
    let eyes: Eyes
    let mouth: Mouth
}
