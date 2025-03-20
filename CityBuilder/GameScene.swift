//
//  GameScene.swift
//  CityBuilder
//
//  Created by RYAN STARK on 2/26/25.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var physicalBuildings: [SKSpriteNode] = []
    
   
    var drop: SKSpriteNode!
    var cam = SKCameraNode()
    var backgroundT: SKSpriteNode!
    var backgroundB: SKSpriteNode!
    var crane : SKSpriteNode!
    var string: SKSpriteNode!
    var casee: SKSpriteNode!
    var power: SKSpriteNode!
    var buildings: [SKSpriteNode] = []
    var holding = false
    var initialCraneY = CGFloat(0)
    var initialCamY = CGFloat(0)
    var construction: SKSpriteNode!
    var moving = false
    var panning = false
    var contactHappen = false
    
    var leader = SKSpriteNode(color: UIColor(red: 100, green: 100, blue: 100, alpha: 0), size: CGSize(width: 10.0, height: 10.0))
    var follow = false
    
    
    

    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        crane = (self.childNode(withName: "crane") as! SKSpriteNode)
        drop = crane.childNode(withName: "drop") as? SKSpriteNode
        string = crane.childNode(withName: "string") as? SKSpriteNode
        casee = crane.childNode(withName: "case") as? SKSpriteNode
        power = crane.childNode(withName: "power") as? SKSpriteNode
//        power.anchorPoint = CGPoint(x: 0, y: 0.5)
//        power.position.x = power.position.x - power.frame.width/2
        backgroundT = (self.childNode(withName: "backgroundT") as! SKSpriteNode)
        backgroundB = (self.childNode(withName: "backgroundB") as! SKSpriteNode)
        construction = (self.childNode(withName: "construction") as! SKSpriteNode)
        self.camera = cam
        initialCamY = backgroundT.position.y + (backgroundB.position.y-backgroundT.position.y)
        cam.position.x = crane.position.x
        cam.position.y = initialCamY
        cam.setScale(1.3)
//        print(cam.frame.width)
//        cam.position.y -= 80
//        cam.setScale(max(background.size.width / self.size.width, background.size.height / self.size.height))
        initialCraneY = crane.position.y
//        print(initialCraneY)
//        print(initialCraneY + ((self.size.height * cam.yScale)/2))
//        cam.run(SKAction.moveTo(y: crane.position.y+300, duration: 2))
        
//        AppData.view.Lose()
//        power.run(SKAction.resize(toWidth: 0, duration: 3))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node!
        let bodyB = contact.bodyB.node!
        if !contactHappen{
            contactHappen = true
            var score = 0.0
            if (bodyA.name != "ground" && bodyB.name != "ground") && (bodyA.name != "Cground" && bodyB.name != "Cground") {
                //            print("bodyA: \(bodyA)")
                //            print("bodyB: \(bodyB)")
                var continuee = true
                if (bodyA.name == "wood" && bodyB.name == "I-Beam") || (bodyA.name == "I-Beam" && bodyB.name == "wood"){
                    var doit = false
                    if bodyA.name == "I-Beam"{
                        if bodyA.position.y > bodyB.position.y {
                            doit = true
                            continuee = false
                        } else {
                            continuee = true
                        }
                    } else {
                        if bodyB.position.y > bodyA.position.y {
                            doit = true
                            continuee = false
                        } else {
                            continuee = true
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
                if continuee{
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
    
    func checkForEdgeScroll(_ touchLocation: CGPoint) {
        let edgeBuffer: CGFloat = 300
        var leftEdge = (cam.position.x - (self.size.width * cam.xScale)/2)
        var rightEdge = (cam.position.x + (self.size.width * cam.xScale)/2)
        leftEdge += edgeBuffer
        rightEdge -= edgeBuffer

        if touchLocation.x < leftEdge {
            if !AppData.moveLeft {
                AppData.moveLeft = true
//                print("Moving Left")
            }
        } else {
            AppData.moveLeft = false
        }

        if touchLocation.x > rightEdge {
            if !AppData.moveRight {
                AppData.moveRight = true
//                print("Moving Right")
            }
        } else {
            AppData.moveRight = false
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        //        print(crane.position.y)
        if !moving{
            if AppData.moveLeft{
                if cam.position.x > ((self.size.width * cam.xScale)/2+25){
                    cam.position.x -= 25
                    if !AppData.view.moveButtons{
                        crane.position.x -= 25
                    }
                } else {
                    cam.position.x = (self.size.width * cam.xScale)/2
                }
            }
            if AppData.moveRight{
                if cam.position.x < ((backgroundT.position.x+backgroundT.frame.width/2) - ((self.size.width * cam.xScale)/2)-25){
                    cam.position.x += 25
                    if !AppData.view.moveButtons{
                        crane.position.x += 25
                    }
                } else {
                    cam.position.x = (backgroundT.position.x+backgroundT.frame.width/2) - ((self.size.width * cam.xScale)/2)
                }
            }
        }
        if holding {
            allBuildings.last!.sprite.position = CGPoint(x: crane.position.x, y: crane.position.y-100)
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
            if cam.position.y > initialCamY{
                cam.position.y = crane.position.y-200
            } else {
                cam.position.y = initialCamY
            }
        }
        if contactHappen{
            _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                self.contactHappen = false
                }
        }
        if follow{
            cam.position.y = leader.position.y
            if cam.position.y == crane.position.y-200{follow=false}
        }
    }
    
    
}
