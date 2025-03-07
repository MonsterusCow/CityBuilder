//
//  GameViewController.swift
//  CityBuilder
//
//  Created by RYAN STARK on 2/26/25.
//

import UIKit
import SpriteKit
import GameplayKit


class AppData{
   
    static var view: GameViewController!
    static var moveLeft = false
    static var moveRight = false
    
    
}

class GameViewController: UIViewController {
    
    var game: GameScene!
    var blockArray: [Block] = [Block(name: "brick", imageID: "brick"),Block(name: "window", imageID: "window"),Block(name: "goop", imageID: "goop")]
    var randomBlockArray: [Block] = []
    
    var score = 0
    
    @IBOutlet weak var scoreOutlet: UILabel!
    
    @IBOutlet weak var button0: UIButton!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    
    
    
    var lastRandomNumber = -1
    
    var buttonArray: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppData.view = self
        
        buttonArray = [self.button0,self.button1,self.button2,self.button3,self.button4]
        
        for _ in 0..<5{
            var random = Int.random(in: 0..<3)
            
            while random == lastRandomNumber{
               random = Int.random(in: 0..<3)
            }
            lastRandomNumber = random
            
            randomBlockArray.append(blockArray[random])
        }
        updateBlocks()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                
                scene.scaleMode = .aspectFill
                game = scene as? GameScene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeRight
        } else {
            return .all
        }
    }
    
    
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: view)
        if let scene = game.view?.scene {
            if let scene = game.view?.scene {
                let convertedLocation = scene.convertPoint(fromView: touchLocation)
                if game.drop.contains(convertedLocation){
                    game.dropBlock()
                }
                
              
            }
        }
    }
        
        @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
            let touchLocation = sender.location(in: view)
            if let scene = game.view?.scene {
                let convertedLocation = scene.convertPoint(fromView: touchLocation)
                game.crane.position.x = convertedLocation.x
                game.string.position.x = convertedLocation.x
                game.drop.position.x = convertedLocation.x
                if game.holding{
                    game.physicalBuildings[game.physicalBuildings.count-1].position.x = convertedLocation.x
                }
                checkHeight()
            }
        }
        
    @IBAction func Buttons(_ sender: Any) {
        var block : Block
        
        
        while randomBlockArray.count < 5{
            
            var random = Int.random(in: 0..<3)
            while random == lastRandomNumber{
               random = Int.random(in: 0..<3)
            }
            lastRandomNumber = random
            
            randomBlockArray.append(blockArray[random])
        }
        
        if button0.isTouchInside{
            block = randomBlockArray[0]
            randomBlockArray.remove(at: 0)
        } else if button1.isTouchInside{
            block = randomBlockArray[1]
            randomBlockArray.remove(at: 1)
        } else if button2.isTouchInside{
            block = randomBlockArray[2]
            randomBlockArray.remove(at: 2)
        } else if button3.isTouchInside{
            block = randomBlockArray[3]
            randomBlockArray.remove(at: 3)
        } else{
            block = randomBlockArray[4]
            randomBlockArray.remove(at: 4)
        }
      
                if !game.holding{
                    if block.imageID == "brick"{
                        game.createBlock(position: CGPoint(x: game.crane.position.x, y: game.crane.position.y-100), block: block, sizex: 200, sizey: 100)
                    } else if block.imageID == "goop"{
                        game.createBlock(position: CGPoint(x: game.crane.position.x, y: game.crane.position.y-100), block: block, sizex: 150, sizey: 45)
                    } else if block.imageID == "window"{
                        game.createBlock(position: CGPoint(x: game.crane.position.x, y: game.crane.position.y-100), block: block, sizex: 200, sizey: 70)
                    }

                    var random = Int.random(in: 0..<3)
                    while random == lastRandomNumber{
                       random = Int.random(in: 0..<3)
                    }
                    lastRandomNumber = random
                    
                    randomBlockArray.append(blockArray[random])
                    
                    updateBlocks()
                    
        }
        
        checkHeight()
        
        
    }
        
    func checkHeight(){
        let beginY: CGFloat = game.initialCraneY // Store the crane’s original height

        var highestBuildingY: CGFloat? = nil // Track the highest building below the crane
        var shouldMoveUp = false // Track if the crane should move up

        // Check for buildings directly beneath the crane
        for (i, building) in game.physicalBuildings.enumerated() {
            // Skip physicalBuildings[game.physicalBuildings.count-1] completely when holding
            if game.holding && i == game.physicalBuildings.count-1 {
                continue
            }

            if game.crane.position.x >= building.position.x - (building.frame.width / 2) - 125 &&
               game.crane.position.x <= building.position.x + (building.frame.width / 2) + 125 {
                
                let buildingTop = building.position.y + building.frame.height / 2
                var verticalDistance: CGFloat = 0

                if !game.holding {
                    verticalDistance = game.crane.position.y - buildingTop
                    if verticalDistance < 100 {
                        game.crane.position.y = buildingTop + 100
                        shouldMoveUp = true
                    }
                } else {
                    let heldBuilding = game.physicalBuildings[game.physicalBuildings.count-1]
                    verticalDistance = (game.crane.position.y + heldBuilding.frame.height) - buildingTop
                    
                    if verticalDistance < (100 + heldBuilding.frame.height) {
                        game.crane.position.y = buildingTop + heldBuilding.frame.height + 100
                        shouldMoveUp = true
                    }
                }

                // Track the highest building below the crane
                if highestBuildingY == nil || buildingTop > highestBuildingY! {
                    highestBuildingY = buildingTop
                }
            }
        }

        // If no buildings are too close, allow the crane to move down
        if !shouldMoveUp {
            if let highestY = highestBuildingY {
                if game.holding {
                    let heldBuilding = game.physicalBuildings[game.physicalBuildings.count-1]
                    game.crane.position.y = max(beginY, highestY + heldBuilding.frame.height + 100)
                } else {
                    if beginY < highestY + 100{
                        game.crane.position.y = highestY + 100
                    } else {
                        game.crane.position.y = beginY
                    }
                }
            } else {
                // No buildings below, return to original start height
                game.crane.position.y = beginY
            }
        }

        // Move the last building along with the crane if it is being held
        if game.holding {
            let lastBuilding = game.physicalBuildings[game.physicalBuildings.count-1]
            lastBuilding.position.y = game.crane.position.y - 100
        }

        // Move string and drop along with the crane
        game.string.position.y = game.crane.position.y + 280
        game.drop.position.y = game.crane.position.y + 85

    }
     
        func updateBlocks(){
            for i in 0..<randomBlockArray.count{
                let image = UIImage(named: randomBlockArray[i].imageID)
                UIGraphicsBeginImageContextWithOptions(CGSize(width: 110, height: 55), false, 1.0)
                image?.draw(in: CGRect(origin: buttonArray[i].accessibilityActivationPoint, size: CGSize(width: 110, height: 55)))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
               
                buttonArray[i].setTitle("", for: .normal)
                buttonArray[i].setImage(newImage, for: .normal)
            }
            
        }
    
    
    
    
    func addScore(){
        score += 1
        scoreOutlet.text = "Score: \(score)"
    }
    
    
    @IBAction func leftAction(_ sender: UIButton) {
//        AppData.moveLeft = true
    }
    
    
    @IBAction func rightAction(_ sender: UIButton) {
//        AppData.moveRight = true
    }
    
        
    }
