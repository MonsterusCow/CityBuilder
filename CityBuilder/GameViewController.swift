//
//  GameViewController.swift
//  CityBuilder
//
//  Created by RYAN STARK on 2/26/25.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {
    
    var game: GameScene!
    var blockArray: [Block] = [Block(name: "brick", imageID: "brick"),Block(name: "brickAlt", imageID: "brickIdeas"),Block(name: "glue", imageID: "glue")]
    var randomBlockArray: [Block] = []
    
    
    @IBOutlet weak var button0: UIButton!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    
    var lastRandomNumber = -1
    
    var buttonArray: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            return .allButUpsideDown
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
            }
        }
        
        @IBAction func makeTheBlock(_ sender: Any) {
            if !game.holding {
                game.createBlock(position: CGPoint(x: game.crane.position.x, y: game.crane.position.y-100), txture: SKTexture(image: UIImage(named: "street")!), sizex: 200, sizey: 100, category: 1, contact: 1)

                
                
            }
        }
        
        @IBAction func lettapLocationsenderlocationinviewlongPressAction(_ sender: UILongPressGestureRecognizer) {
            let tapLocation = sender.location(in: view)
            let touchLocation = sender.location(in: view)
            if let scene = game.view?.scene {
                let convertedLocation = scene.convertPoint(fromView: touchLocation)
                
            }
        }
        
     
        
        func blockClicked(buttonClicked: Int){
            
            
            
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
        
        
        
    }
