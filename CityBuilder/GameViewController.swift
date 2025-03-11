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
                let convertedLocation = scene.convertPoint(fromView: touchLocation)
                let dropLocalLocation = game.crane.convert(convertedLocation, from: scene)
                if game.crane.childNode(withName: "drop")!.contains(dropLocalLocation) {
                    dropBuilding()
                    game.holding = false
                    print("www")
                }
            }
    }
        
        @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
            let touchLocation = sender.location(in: view)
                if let scene = game.view?.scene {
                    let convertedLocation = scene.convertPoint(fromView: touchLocation)
                    
                    game.crane.position.x = convertedLocation.x
//                    game.string.position.x = convertedLocation.x
//                    game.drop.position.x = convertedLocation.x
                    
                    if game.holding, let lastBuilding = allBuildings.last {
                        lastBuilding.sprite.position.x = convertedLocation.x
                    }

                    checkHeight()
                }
        }
        
    @IBAction func Buttons(_ sender: Any) {
        var block: Block
            
            // Ensure at least 5 blocks in the queue
            while randomBlockArray.count < 5 {
                var random = Int.random(in: 0..<3)
                while random == lastRandomNumber {
                    random = Int.random(in: 0..<3)
                }
                lastRandomNumber = random
                randomBlockArray.append(blockArray[random])
            }
            
        if !game.holding {
            // Select block based on button press
            if button0.isTouchInside {
                block = randomBlockArray[0]
                randomBlockArray.remove(at: 0)
            } else if button1.isTouchInside {
                block = randomBlockArray[1]
                randomBlockArray.remove(at: 1)
            } else if button2.isTouchInside {
                block = randomBlockArray[2]
                randomBlockArray.remove(at: 2)
            } else if button3.isTouchInside {
                block = randomBlockArray[3]
                randomBlockArray.remove(at: 3)
            } else {
                block = randomBlockArray[4]
                randomBlockArray.remove(at: 4)
            }

            let size: CGSize
            switch block.imageID {
            case "brick": size = CGSize(width: 200, height: 100)
            case "goop": size = CGSize(width: 150, height: 45)
            case "window": size = CGSize(width: 200, height: 70)
            default: size = CGSize(width: 100, height: 100)
            }
            
            createBuilding(block: block, sizex: Int(size.width), sizey: Int(size.height), scene: game)
            game.holding = true
            
            var random = Int.random(in: 0..<3)
            while random == lastRandomNumber {
                random = Int.random(in: 0..<3)
            }
            lastRandomNumber = random
            randomBlockArray.append(blockArray[random])
            
            updateBlocks()
            checkHeight()
        }
    }
        
    func checkHeight(){
        let beginY: CGFloat = game.initialCraneY
           var highestBuildingY: CGFloat? = nil
           var shouldMoveUp = false

           for (i, building) in allBuildings.enumerated() {
               if game.holding && i == allBuildings.count - 1 { continue }

               if game.crane.position.x >= building.sprite.position.x - (building.sprite.size.width / 2) - 125 &&
                  game.crane.position.x <= building.sprite.position.x + (building.sprite.size.width / 2) + 125 {

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
               if let highestY = highestBuildingY {
                   if game.holding, let heldBuilding = allBuildings.last {
                       game.crane.position.y = max(beginY, highestY + heldBuilding.sprite.size.height + 100)
                   } else {
                       game.crane.position.y = max(beginY, highestY + 100)
                   }
               } else {
                   game.crane.position.y = beginY
               }
           }

           if game.holding, let lastBuilding = allBuildings.last {
               lastBuilding.sprite.position.y = game.crane.position.y - 100
           }

//           game.string.position.y = game.crane.position.y + 280
//           game.drop.position.y = game.crane.position.y + 85

    }
     
        func updateBlocks(){
            for i in 0..<randomBlockArray.count {
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
        score += 5
        scoreOutlet.text = "Score: \(score)"
    }
    
    
    @IBAction func leftAction(_ sender: UIButton) {
        AppData.moveLeft = true
    }
    

    @IBAction func leftActionEnd(_ sender: UIButton) {
        AppData.moveLeft = false
    }
    
    
    @IBAction func leftActionEnd2(_ sender: UIButton) {
        AppData.moveLeft = false
    }
    
    @IBAction func rightAction(_ sender: UIButton) {
        AppData.moveRight = true
    }
    
    
    @IBAction func rightActionEnd(_ sender: UIButton) {
        AppData.moveRight = false
    }
    
    
    @IBAction func rightActionEnd2(_ sender: UIButton) {
        AppData.moveRight = false
    }
    
    
    
        
    }
