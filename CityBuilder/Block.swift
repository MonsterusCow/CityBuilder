//
//  Block.swift
//  CityBuilder
//
//  Created by PETER MICKLE on 3/4/25.
//

import Foundation

class Block{
    
    var name : String
    var imageID : String
    
    init(name: String, imageID: String) {
        self.name = name
        self.imageID = imageID
    }
    
    
}

class Buildings {
    
    var block: Block
    var height: Double
    var width: Double

    init(block: Block, height: Double, width: Double) {
        self.block = block
        self.height = height
        self.width = width
    }
    
}
