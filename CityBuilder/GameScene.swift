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

        self.sprite = SKSpriteNode(texture: SKTexture(imageNamed: block.imageID), size: size)
        self.sprite.position = position
        self.sprite.zPosition = 3
//        
        self.sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: block.imageID), size: size)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.sprite.physicsBody?.allowsRotation = false
        self.sprite.physicsBody?.restitution = 0
        self.sprite.physicsBody?.linearDamping = 1
        self.sprite.physicsBody?.angularDamping = 0.2
        self.sprite.physicsBody?.categoryBitMask = 1
        self.sprite.physicsBody?.collisionBitMask = 1
        self.sprite.physicsBody?.contactTestBitMask = 1

        scene.addChild(self.sprite)
    }
}

// Global lists to track buildings
var allBuildings: [Building] = []

// Function to create and place a building
func createBuilding(block: Block, sizex: Int, sizey: Int, scene: GameScene) {
    let size = CGSize(width: sizex, height: sizey)
    let building = Building(block: block, position: CGPoint(x: scene.construction.position.x, y: (scene.construction.position.y-300)), size: size, scene: scene)
    allBuildings.append(building)
    
    moveCraneToBuilding(building: building, game: scene)
}



func moveCraneToBuilding(building: Building,game: GameScene) {
    guard let gameScene = game.view?.scene else { return }
    
   
    
    // 1. Move crane horizontally to the building
    let moveHorizontally = SKAction.moveTo(x: building.sprite.position.x, duration: 0.5)
    
    // 2. Lower crane to building's height
    let lowerCrane = SKAction.moveTo(y: building.sprite.position.y + 100, duration: 0.75)
    
    // 3. Attach the building (simulate picking up)
    let grabBlock = SKAction.run {
        game.holding = true
        building.sprite.position.y = game.crane.position.y - 100
        game.physicalBuildings.append(building.sprite)
    }
    
    // 4. Raise crane back up
    let raiseCrane = SKAction.customAction(withDuration: 1.0) { node, elapsedTime in
            building.sprite.physicsBody?.affectedByGravity = false
        building.sprite.physicsBody?.categoryBitMask = 0
        building.sprite.physicsBody?.collisionBitMask = 0
        building.sprite.physicsBody?.contactTestBitMask = 0
            let progress = elapsedTime / 1.0 // Normalize time (0 to 1)
            let newY = game.initialCraneY * progress + (building.sprite.position.y + 100) * (1 - progress)
            game.crane.position.y = newY
            building.sprite.position.y = newY - 100
        }
    // 5. Sequence of actions
    let sequence = SKAction.sequence([moveHorizontally, lowerCrane, grabBlock, raiseCrane])
    
    // Run animation on crane
    game.crane.run(sequence)
    
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
    var construction: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
       
        
        physicsWorld.contactDelegate = self
        crane = (self.childNode(withName: "crane") as! SKSpriteNode)
        drop = crane.childNode(withName: "drop") as? SKSpriteNode
        string = crane.childNode(withName: "string") as? SKSpriteNode
        background = (self.childNode(withName: "background") as! SKSpriteNode)
        construction = (self.childNode(withName: "construction") as! SKSpriteNode)
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
            AppData.view.addScore()
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
        if cam.position.x > 0 + 1450{
            if AppData.moveLeft{
                cam.position.x -= 5
            }
        }
      
        if cam.position.x < 3200 - 1450{
            if AppData.moveRight{
                cam.position.x += 5
            }
        }
      
        
        
    }
}
