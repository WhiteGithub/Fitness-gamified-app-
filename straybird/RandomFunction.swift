//
//  RandomFunction.swift
//  straybird
//
//  Created by yu ni on 2016-08-19.
//  Copyright © 2016 yu ni. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{

    
    public static func random() ->CGFloat{
         return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    public static func random(min min:CGFloat, max: CGFloat)->CGFloat{
        return CGFloat.random() * (max-min)+min
    }
}