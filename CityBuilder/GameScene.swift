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
    //between 0-1
    var rarity: Double

    init(name: String, imageID: String, rarity: Double) {
        self.name = name
        self.imageID = imageID
        self.rarity = rarity
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
    allBuildings.last!.sprite.physicsBody?.affectedByGravity = true
    if allBuildings.last!.block.imageID != "gold"{
        allBuildings.last!.sprite.physicsBody?.allowsRotation = true
    }
    allBuildings.last!.sprite.physicsBody?.categoryBitMask = 1
    allBuildings.last!.sprite.physicsBody?.contactTestBitMask = 1
    allBuildings.last!.sprite.physicsBody?.collisionBitMask = 1
    allBuildings.last!.sprite.physicsBody?.mass = 20
    game.crane.texture = SKTexture(image: UIImage(named: "claw")!)
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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var physicalBuildings: [SKSpriteNode] = []
    
   
    var drop: SKSpriteNode!
    var cam = SKCameraNode()
    var backgroundT: SKSpriteNode!
    var backgroundB: SKSpriteNode!
    var crane : SKSpriteNode!
    var string: SKSpriteNode!
    var buildings: [SKSpriteNode] = []
    var holding = false
    var initialCraneY = CGFloat(0)
    var construction: SKSpriteNode!
    var moving = false
    

    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        crane = (self.childNode(withName: "crane") as! SKSpriteNode)
        drop = crane.childNode(withName: "drop") as? SKSpriteNode
        string = crane.childNode(withName: "string") as? SKSpriteNode
        backgroundT = (self.childNode(withName: "backgroundT") as! SKSpriteNode)
        backgroundB = (self.childNode(withName: "backgroundB") as! SKSpriteNode)
        construction = (self.childNode(withName: "construction") as! SKSpriteNode)
        self.camera = cam
        cam.position.y = backgroundT.position.y + (backgroundB.position.y-backgroundT.position.y)
        cam.position.x = crane.position.x
        cam.setScale(1.3)
//        print(cam.frame.width)
//        cam.position.y -= 80
//        cam.setScale(max(background.size.width / self.size.width, background.size.height / self.size.height))
        initialCraneY = crane.position.y

//        createBuilding(position: CGPoint(x: crane.position.x, y: crane.position.y-100), block: Block(name: "road", imageID: "street"), sizex: 200, sizey: 200, scene: self)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node!
        let bodyB = contact.bodyB.node!
        var score = 0.0
        if (bodyA.name != "ground" && bodyB.name != "ground") && (bodyA.name != "Cground" && bodyB.name != "Cground") {
//            print("bodyA: \(bodyA)")
//            print("bodyB: \(bodyB)")
            if bodyA.name == "wood" || bodyB.name == "wood"{
                print("yes")
                if bodyA.name == "I-Beam" || bodyB.name == "I-Beam"{
                    var doit = false
                    if bodyA.name == "I-Beam"{
                        if bodyA.position.y > bodyB.position.y {
                            doit = true
                        }
                    } else {
                        if bodyB.position.y > bodyA.position.y {
                            doit = true
                        }
                    }
                    if doit{
                        if bodyA.name == "wood"{
                            bodyA.removeFromParent()
                            giveScoreIndicatior(at: bodyA.position, score: "CRUSH", game: self, color: .red)
                        } else {
                            bodyB.removeFromParent()
                            giveScoreIndicatior(at: bodyB.position, score: "CRUSH", game: self, color: .red)
                        }
                    }
                }
            } else {
                //if blocks allign middles
                if bodyA.position.x > (bodyB.position.x - (bodyB.frame.width/10)) && bodyA.position.x < (bodyB.position.x + (bodyB.frame.width/10)){
                    score += 10.0
                    if bodyA.position.y < bodyB.position.y && bodyA.frame.width > bodyB.frame.width || bodyB.position.y < bodyA.position.y && bodyB.frame.width > bodyA.frame.width {
                        score *= 1.5
                    }
                    if score > 0{
                        giveScoreIndicatior(at: CGPoint(x:crane.position.x,y:max(bodyA.position.y, bodyB.position.y)), score: "+\(score)", game: self, color: .red)
                    }
                    AppData.view?.score += score
                    AppData.view?.scoreOutlet.text = "Score: \(AppData.view!.score)"
                } else if bodyA.frame.width != bodyB.frame.width{
                    //if blocks allign edges
                        let bodyAedgeL = bodyA.position.x-bodyA.frame.width/2
                        let bodyAedgeR = bodyA.position.x+bodyA.frame.width/2
                        let bodyBedgeL = bodyB.position.x-bodyB.frame.width/2
                        let bodyBedgeR = bodyB.position.x+bodyB.frame.width/2
                        if bodyAedgeL > bodyBedgeL-5 && bodyAedgeL < bodyBedgeL+5{
                            score += 10
                        }
                        if bodyAedgeR > bodyBedgeR-5 && bodyAedgeR < bodyBedgeR+5{
                            score += 10
                        }
                        if score != 0{
                            giveScoreIndicatior(at: CGPoint(x:crane.position.x,y:max(bodyA.position.y, bodyB.position.y)), score: "+\(score)", game: self, color: .red)
                        }
                        AppData.view?.score += score
                        AppData.view?.scoreOutlet.text = "Score: \(AppData.view!.score)"
                } else if abs(bodyA.zRotation) > 0.785 || abs(bodyB.zRotation) > 0.785 {
                        score = -20
                        giveScoreIndicatior(at: CGPoint(x:crane.position.x,y:max(bodyA.position.y, bodyB.position.y)), score: "-20", game: self, color: .red)
                        AppData.view?.score += score
                        AppData.view?.scoreOutlet.text = "Score: \(AppData.view!.score)"
                }
            }
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
        if !moving{
            if AppData.moveLeft{
                if cam.position.x > ((self.size.width * cam.xScale)/2+25){
//                    print("cam: \(cam.position.x)")
//                    print("Visible Width: \(self.size.width * cam.xScale)")
//                    print("Min X (Leftmost): \((self.size.width * cam.xScale)/2)")
                    cam.position.x -= 25
                } else {
                    cam.position.x = (self.size.width * cam.xScale)/2
                }
            }
            if AppData.moveRight{
                if cam.position.x < ((backgroundT.position.x+backgroundT.frame.width/2) - ((self.size.width * cam.xScale)/2)-25){
                    cam.position.x += 25
                } else {
                    cam.position.x = (backgroundT.position.x+backgroundT.frame.width/2) - ((self.size.width * cam.xScale)/2)
                }
            }
        }
        if moving{
            if cam.position.x <= ((self.size.width * cam.xScale)/2)+1 {
                cam.position.x = ((self.size.width * cam.xScale)/2)
            } else {
                cam.position.x = crane.position.x
            }
            if holding{
                allBuildings.last!.sprite.position = CGPoint(x: crane.position.x, y: crane.position.y-100)
                AppData.view.checkHeight()
            }
        }
        if crane.position.y > initialCraneY + ((self.size.height * cam.yScale)/2)-300 {
            cam.position.y = crane.position.y-100
        } else {
            cam.position.y = backgroundT.position.y + (backgroundB.position.y-backgroundT.position.y)
        }
        
    
        
        
        
    }
}
