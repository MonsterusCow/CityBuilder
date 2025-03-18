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
    var blockArray: [Block] = [Block(name: "brick", imageID: "brick", rarity: 1.0),Block(name: "window", imageID: "window", rarity: 0.7),Block(name: "gold", imageID: "gold", rarity: 0.1), Block(name: "I-Beam", imageID: "I-Beam", rarity: 0.4), Block(name: "wood", imageID: "wood", rarity: 1.0), Block(name: "billboard", imageID: "billboard", rarity: 0.2)]
//    Block(name: "goop", imageID: "goop", rarity: 0.5),
    var randomBlockArray: [Block] = []
    
    var score = 0.0
    
    @IBOutlet weak var scoreOutlet: UILabel!
    
    @IBOutlet weak var button0: UIButton!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    
    var moveButtons = false

    
    var lastRandomNumber = -1
    
    var buttonArray: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppData.view = self
        
        buttonArray = [self.button0,self.button1,self.button2,self.button3,self.button4]
                
        addBlocksToRandomArray()
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
        return .landscapeRight
    }
    
    
    //moves the crane left and right
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        print("tap")
        let touchLocation = sender.location(in: view)
            if let scene = game.view?.scene {
                if game.holding && !game.construction.contains(CGPoint(x:game.crane.position.x-(allBuildings.last!.width/2),y:game.construction.position.y)){
                    let convertedLocation = scene.convertPoint(fromView: touchLocation)
                    let dropLocalLocation = game.crane.convert(convertedLocation, from: scene)
                    if game.crane.childNode(withName: "drop")!.contains(dropLocalLocation) {
                        dropBuilding(game: game)
                        game.holding = false
                    }
                }
            }
    }
        
        @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
            if !game.moving{
                let touchLocation = sender.location(in: view)
                if let scene = game.view?.scene {
                    let convertedLocation = scene.convertPoint(fromView: touchLocation)
                    
                    game.checkForEdgeScroll(convertedLocation)
                    game.crane.position.x = convertedLocation.x
                    
                    if game.holding, let lastBuilding = allBuildings.last {
                        lastBuilding.sprite.position.x = convertedLocation.x
                    }
                    
                    
                    checkHeight()
                }
            }
        }
        
    @IBAction func Buttons(_ sender: Any) {
        var block: Block
        
        // Ensure at least 5 blocks in the queue
        addBlocksToRandomArray()
        
        // Select block based on button press
        if !game.holding {
            // Select block based on button press
            if button0.isTouchInside {
                block = randomBlockArray[0]
            } else if button1.isTouchInside {
                block = randomBlockArray[1]
            } else if button2.isTouchInside {
                block = randomBlockArray[2]
            } else if button3.isTouchInside {
                block = randomBlockArray[3]
            } else {
                block = randomBlockArray[4]
                randomBlockArray.remove(at: 4)
            }
            randomBlockArray.removeAll()
            
            if block.imageID == "brick"{
                createBuilding(block: block, sizex: 200, sizey: 100, scene: game)
            } else if block.imageID == "goop"{
                createBuilding(block: block, sizex: 150, sizey: 45, scene: game)
            } else if block.imageID == "window" {
                createBuilding(block: block, sizex: 100, sizey: 100, scene: game)
            } else if block.imageID == "gold" {
                createBuilding(block: block, sizex: 200, sizey: 100, scene: game)
            } else if block.imageID == "I-Beam" {
                createBuilding(block: block, sizex: 400, sizey: 100, scene: game)
            } else if block.imageID == "wood" {
                createBuilding(block: block, sizex: 200, sizey: 45, scene: game)
            } else if block.imageID == "billboard" {
                createBuilding(block: block, sizex: 475, sizey: 200, scene: game)
            }
            
            
            addBlocksToRandomArray()
            
            updateBlocks()
            checkHeight()
        }
    }
    
    //makes the crane move up and down
    func checkHeight(){
        let beginY: CGFloat = game.initialCraneY
           var highestBuildingY: CGFloat? = nil
           var shouldMoveUp = false

           for (i, building) in allBuildings.enumerated() {
               if game.holding && i == allBuildings.count - 1 { continue }
               
               var holdBuilding = allBuildings.last!.width/2
               if !game.holding {
                   holdBuilding = 0
               }
               if game.crane.position.x >= building.sprite.position.x - (building.sprite.frame.width / 2) - holdBuilding &&
                    game.crane.position.x <= building.sprite.position.x + (building.sprite.frame.width / 2) + holdBuilding {

                   let buildingTop = building.sprite.position.y + building.sprite.size.height / 2
                   var verticalDistance: CGFloat = 0

                   if !game.holding {
                       verticalDistance = game.crane.position.y - buildingTop
                       if verticalDistance < 100 {
                           game.crane.position.y = buildingTop + 100
                           shouldMoveUp = true
                       }
                   } else if let heldBuilding = allBuildings.last {
                       verticalDistance = (game.crane.position.y + heldBuilding.sprite.size.height) - buildingTop
                       if verticalDistance < (100 + heldBuilding.sprite.size.height) {
                           game.crane.position.y = buildingTop + heldBuilding.sprite.size.height + 100
                           shouldMoveUp = true
                       }
                   }

                   if highestBuildingY == nil || buildingTop > highestBuildingY! {
                       highestBuildingY = buildingTop
                   }
               }
           }

           if !shouldMoveUp {
               let moveAction: SKAction
               if let highestY = highestBuildingY {
                   
                   if game.holding, let heldBuilding = allBuildings.last {
                       game.crane.position.y = max(beginY, highestY + heldBuilding.sprite.size.height + 100)
//                        moveAction = SKAction.moveTo(y: max(beginY, highestY + heldBuilding.sprite.size.height + 100), duration: 0.5)
//                       moveAction.timingMode = .easeInEaseOut

                   } else {
                       game.crane.position.y = max(beginY, highestY + 100)
//                    moveAction = SKAction.moveTo(y: max(beginY, highestY + 100), duration: 0.5)
//                       moveAction.timingMode = .easeInEaseOut

                   }
               } else {
                   game.crane.position.y = beginY
               }
           }

        if game.holding, let lastBuilding = allBuildings.last {
            lastBuilding.sprite.position.y = game.crane.position.y - 100
        }
        
        if game.crane.position.y > (game.initialCraneY + ((game.size.height * game.cam.yScale)/2) - 400)  {
            print("did")
            //cam wont do skaction
//            game.cam.run(SKAction.moveTo(y: game.crane.position.y-100, duration: 0.25))
            game.cam.position.y = game.crane.position.y-100
        } else {
//            game.cam.run(SKAction.moveTo(y: game.backgroundT.position.y + (game.backgroundB.position.y-game.backgroundT.position.y), duration: 0.25))
            game.cam.position.y = game.backgroundT.position.y + (game.backgroundB.position.y-game.backgroundT.position.y)
        }
    }
     //updates the images on the block menu
        func updateBlocks(){
            for i in 0...4 {
                    let image = UIImage(named: randomBlockArray[i].imageID)
                    UIGraphicsBeginImageContextWithOptions(CGSize(width: 110, height: 55), false, 1.0)
                    image?.draw(in: CGRect(origin: buttonArray[i].accessibilityActivationPoint, size: CGSize(width: 110, height: 55)))
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    buttonArray[i].setTitle("", for: .normal)
                    buttonArray[i].setImage(newImage, for: .normal)
                }
            
            
        }
    
    
    
    //adds score
    func addScore(){
        score += 5
        scoreOutlet.text = "Score: \(score)"
    }
    
    //buttons to move camera
    @IBAction func leftAction(_ sender: UIButton) {
        AppData.moveLeft = true
        moveButtons = true
    }
    

    @IBAction func leftActionEnd(_ sender: UIButton) {
        AppData.moveLeft = false
        moveButtons = false
    }
    
    
    
    @IBAction func rightAction(_ sender: UIButton) {
        AppData.moveRight = true
        moveButtons = true
    }
    
    
    @IBAction func rightActionEnd(_ sender: UIButton) {
        AppData.moveRight = false
        moveButtons = false
    }
    
    
    //cool rarity thing
    func addBlocksToRandomArray(){
        while randomBlockArray.count < 5 {
            var randomTo = 0.0
            var blockArrayByRarity : [Double] = []
            for i in 0...blockArray.count-1 {
                randomTo += blockArray[i].rarity
                blockArrayByRarity.append(blockArray[i].rarity)
            }
            let random = Double.random(in: 0..<randomTo)
            var nextRarity = 0.0
            var thisRarity = 0.0
            var chosenIndex : Int!
            for i in 0...blockArrayByRarity.count-1{
                nextRarity += blockArrayByRarity[i]
                if i != 0{
                    thisRarity += blockArrayByRarity[i-1]
                }
              
                if random >= thisRarity && random <= nextRarity{
                    chosenIndex = i
                }
//                print(random)
//                print(nextRarity)
//                print(thisRarity)
            }
            
            randomBlockArray.append(blockArray[chosenIndex])
            
        }
    }
    
    
    @IBAction func HpwToPlayAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toTutorial", sender: self)
    }
    
        
    }
