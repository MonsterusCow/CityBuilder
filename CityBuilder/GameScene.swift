//
//  GameScene.swift
//  CityBuilder
//
//  Created by RYAN STARK on 2/26/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var drop: SKSpriteNode!
    let cam = SKCameraNode()
    var crane : SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        drop = self.childNode(withName: "drop") as? SKSpriteNode
        self.camera = cam
        AppData.game = self
        crane = (self.childNode(withName: "crane") as! SKSpriteNode)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if drop.contains(pos){
            print("drop now")
        }
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
        cam.pos = crane.pos
    }
}
