//
//  GameScene.swift
//  CityBuilder
//
//  Created by RYAN STARK on 2/26/25.
//

import SpriteKit
import GameplayKit

// Base Block class
class Block {
    var name: String
    var imageID: String

    init(name: String, imageID: String) {
        self.name = name
        self.imageID = imageID
    }
}

// Building class that directly manages its sprite
class Building {
    var block: Block
    var height: Double
    var width: Double
    var sprite: SKSpriteNode

    init(block: Block, position: CGPoint, size: CGSize, scene: SKScene) {
        self.block = block
        self.height = Double(size.height)
        self.width = Double(size.width)

        // Create and configure the sprite
        self.sprite = SKSpriteNode(texture: SKTexture(imageNamed: block.imageID), size: size)
        self.sprite.position = position
        self.sprite.zPosition = 3
        
        // Add physics body
        self.sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: block.imageID), size: size)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = false
        self.sprite.physicsBody?.allowsRotation = false
        self.sprite.physicsBody?.restitution = 0
        self.sprite.physicsBody?.linearDamping = 1
        self.sprite.physicsBody?.angularDamping = 0.2
        self.sprite.physicsBody?.categoryBitMask = 0
        self.sprite.physicsBody?.collisionBitMask = 0
        self.sprite.physicsBody?.contactTestBitMask = 0

        // Add to the scene
        scene.addChild(self.sprite)
    }
}

// Global lists to track buildings
var allBuildings: [Building] = []

// Function to create and place a building
func createBuilding(position: CGPoint, block: Block, sizex: Int, sizey: Int, scene: SKScene) {
    let size = CGSize(width: sizex, height: sizey)
    let building = Building(block: block, position: position, size: size, scene: scene)
    allBuildings.append(building)
}

// Function to drop the last created building
func dropBuilding() {
    guard let lastBuilding = allBuildings.last else { return }
    
    lastBuilding.sprite.physicsBody?.affectedByGravity = true
    lastBuilding.sprite.physicsBody?.categoryBitMask = 1
    lastBuilding.sprite.physicsBody?.contactTestBitMask = 1
    lastBuilding.sprite.physicsBody?.collisionBitMask = 1
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var physicalBuildings: [SKSpriteNode] = []
    
   
    var drop: SKSpriteNode!
    var cam = SKCameraNode()
    var background: SKSpriteNode!
    var crane : SKSpriteNode!
    var string: SKSpriteNode!
    var buildings: [SKSpriteNode] = []
    var holding = false
    var initialCraneY = CGFloat(0)
    
    override func didMove(to view: SKView) {
        
       
        
        physicsWorld.contactDelegate = self
        drop = self.childNode(withName: "drop") as? SKSpriteNode
        string = self.childNode(withName: "string") as? SKSpriteNode
        background = (self.childNode(withName: "background") as! SKSpriteNode)
        crane = (self.childNode(withName: "crane") as! SKSpriteNode)
        self.camera = cam
        cam.position = background.position
        cam.position.y -= 80
        cam.setScale(max(background.size.width / self.size.width, background.size.height / self.size.height))
        initialCraneY = crane.position.y

//        createBuilding(position: CGPoint(x: crane.position.x, y: crane.position.y-100), block: Block(name: "road", imageID: "street"), sizex: 200, sizey: 200, scene: self)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node!
        let bodyB = contact.bodyB.node!
        if bodyA.position.x > (bodyB.position.x - (bodyB.frame.height/2)) && bodyA.position.x < (bodyB.position.x + (bodyB.frame.height/2)){
            print("good align")
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        //        print(crane.position.y)
    
        if AppData.moveLeft{
            cam.position.x -= 5
        }
           
        if AppData.moveRight{
            cam.position.x += 5
        }
        
        
    }
}
