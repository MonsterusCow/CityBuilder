//
//  Building and Block.swift
//  CityBuilder
//
//  Created by RYAN STARK on 3/19/25.
//

import Foundation
import SpriteKit
import GameplayKit


// Base Block class
class Block {
    var name: String
    var imageID: String
    //between 0-1
    var rarity: Double

    init(name: String, imageID: String, rarity: Double) {
        self.name = name
        self.imageID = imageID
        self.rarity = rarity
    }
}

// Building class that directly manages its sprite
class Building: Equatable {
    var block: Block
    var height: Double
    var width: Double
    var sprite: SKSpriteNode

    init(block: Block, position: CGPoint, size: CGSize, scene: SKScene) {
        self.block = block
        self.height = Double(size.height)
        self.width = Double(size.width)

        self.sprite = SKSpriteNode(texture: SKTexture(imageNamed: block.imageID), size: size)
        self.sprite.position = position
        self.sprite.zPosition = 3

        //makes alpha mask bodies
//        self.sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: block.imageID), size: size)
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.sprite.physicsBody?.allowsRotation = false
        self.sprite.physicsBody?.restitution = 0
        self.sprite.physicsBody?.linearDamping = 1
        self.sprite.physicsBody?.angularDamping = 0.2
        self.sprite.physicsBody?.categoryBitMask = 1
        self.sprite.physicsBody?.collisionBitMask = 1
        self.sprite.physicsBody?.contactTestBitMask = 1
        self.sprite.physicsBody?.node?.name = block.name

        scene.addChild(self.sprite)
    }
    
    static func == (lhs: Building, rhs: Building) -> Bool {
        return lhs.block.name == rhs.block.name && lhs.height == rhs.height
        }
}

// Global lists to track buildings
var allBuildings: [Building] = []

// Function to create and place a building
func createBuilding(block: Block, sizex: Int, sizey: Int, scene: GameScene) {
    let size = CGSize(width: sizex, height: sizey)
    let building = Building(block: block, position: CGPoint(x: scene.construction.position.x, y: (scene.construction.position.y-300)), size: size, scene: scene)
    allBuildings.append(building)
    print("appended")
    
    moveCraneToBuilding(building: building, game: scene)
}



func moveCraneToBuilding(building: Building,game: GameScene) {
    game.moving = true
    let moveHorizontally = SKAction.moveTo(x: building.sprite.position.x, duration: 0.75)
    
    let openCrane = SKAction.run {game.crane.texture = SKTexture(image: UIImage(named: "open_claw")!)}
    let lowerCrane = SKAction.moveTo(y: building.sprite.position.y, duration: 0.75)
    
    let grabBlock = SKAction.run {
        game.holding = true
        building.sprite.position.y = game.crane.position.y - 100
        game.physicalBuildings.append(building.sprite)
    }
    
    let raiseCrane = SKAction.group([
        SKAction.moveTo(y: game.initialCraneY, duration: 0.75),
        SKAction.run {
            building.sprite.physicsBody?.affectedByGravity = false
            building.sprite.physicsBody?.categoryBitMask = 0
            building.sprite.physicsBody?.collisionBitMask = 0
            building.sprite.physicsBody?.contactTestBitMask = 0
        },
        SKAction.run {
            building.sprite.run(SKAction.moveTo(y: game.initialCraneY - 100, duration: 0.75))
        }
    ])
    
    let moveBack = SKAction.moveTo(x: game.construction.position.x+CGFloat((300+Int.random(in: 0...200))), duration: 0.75)
    
    let finish = SKAction.run {
        building.sprite.position.x = game.crane.position.x
        game.moving = false
    }
    
    let sequence = SKAction.sequence([moveHorizontally, openCrane, lowerCrane, grabBlock, raiseCrane, moveBack, finish])
    game.crane.run(sequence)
}

// Function to drop the last created building
func dropBuilding(game: GameScene) {
    allBuildings.last!.sprite.removeFromParent()
    game.addChild(allBuildings.last!.sprite)
    if allBuildings.last!.block.name == "billboard"{
        allBuildings.last!.sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: allBuildings.last!.block.imageID), size: allBuildings.last!.sprite.size)
    }
    allBuildings.last!.sprite.physicsBody?.affectedByGravity = true
    if allBuildings.last!.block.imageID != "gold"{
        allBuildings.last!.sprite.physicsBody?.allowsRotation = true
    }
    allBuildings.last!.sprite.physicsBody?.categoryBitMask = 1
    allBuildings.last!.sprite.physicsBody?.contactTestBitMask = 1
    allBuildings.last!.sprite.physicsBody?.collisionBitMask = 1
    allBuildings.last!.sprite.physicsBody?.mass = 20
    game.crane.texture = SKTexture(image: UIImage(named: "claw")!)
    
    let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
        
        if AppData.view.score < AppData.view.quota{
            
        }
        }

}

func giveScoreIndicatior(at position: CGPoint, score: String, game: GameScene, color: UIColor) {
    let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    scoreLabel.text = score
    scoreLabel.fontSize = 45
    scoreLabel.fontColor = color
    scoreLabel.position = position
    scoreLabel.zPosition = 10
    
    game.addChild(scoreLabel)
    
    let moveUp = SKAction.moveBy(x: CGFloat(Int.random(in: -75...75)), y: 100, duration: 1.5)
    let fadeOut = SKAction.fadeOut(withDuration: 1.5)
    let remove = SKAction.removeFromParent()
    let sequence = SKAction.sequence([SKAction.group([moveUp, fadeOut]), remove])
    
    scoreLabel.run(sequence)
}
