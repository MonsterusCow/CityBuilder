//
//  GameScene.swift
//  CityBuilder
//
//  Created by RYAN STARK on 2/26/25.
//

import SpriteKit
import GameplayKit

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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var allBuildings: [Buildings] = []
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

//        createBlock(position: CGPoint(x: crane.position.x, y: crane.position.y-100), block: Block(name: "road", imageID: "street"), sizex: 200, sizey: 100)
        
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
    
    func createBlock(position: CGPoint, block: Block, sizex: Int, sizey: Int){
        let building = Buildings(block: block, height: Double(sizey), width: Double(sizex))
        allBuildings.append(building)
        
        let spriteSize = CGSize(width: sizex, height: sizey)
        let sprite = SKSpriteNode(texture: SKTexture(image: UIImage(named: block.imageID)!), size: spriteSize)
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(image: UIImage(named: block.imageID)!), size: spriteSize)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.restitution = 0
        sprite.physicsBody?.linearDamping = 1
        sprite.physicsBody?.angularDamping = 0.2
        sprite.physicsBody?.categoryBitMask = 0
        sprite.physicsBody?.collisionBitMask = 0
        sprite.physicsBody?.contactTestBitMask = 0
        sprite.zPosition = 3
        physicalBuildings.append(sprite)
        self.addChild(sprite)
        
        holding = true
        crane.texture = SKTexture(image: UIImage(named: "open_claw")!)
    }
    
    func dropBlock(){
        holding = false
        physicalBuildings[physicalBuildings.count-1].physicsBody?.affectedByGravity = true
        physicalBuildings[physicalBuildings.count-1].physicsBody?.categoryBitMask = 1
        physicalBuildings[physicalBuildings.count-1].physicsBody?.contactTestBitMask = 1
        physicalBuildings[physicalBuildings.count-1].physicsBody?.collisionBitMask = 1


        crane.texture = SKTexture(image: UIImage(named: "claw")!)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        //        print(crane.position.y)
    
//        if AppData.moveLeft{
//            cam.position.x -= 1
//        }
//           
//        if AppData.moveRight{
//            cam.position.x += 1
//        }
        
        
    }
}
