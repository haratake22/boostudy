//
//  Picker.swift
//  boostudy
//
//  Created by Kasumi on 2021/07/20.
//

import Foundation

class Picker{
    
    static func gender() -> [String]{
        ["男性","女性"]
    }
    
    static func age() -> [Int]{
        ([Int])(18...80)
    }
    
    static func time() -> [Int]{
        ([Int])(0...24)
    }
}
