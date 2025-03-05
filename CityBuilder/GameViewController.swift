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
    
    var buttonArray: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonArray = [self.button0,self.button1,self.button2,self.button3,self.button4]
        
        for _ in 0..<5{
            randomBlockArray.append(blockArray[Int.random(in: 0..<3)])
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
                
                game.crane.position.x = convertedLocation.x
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
                    game.buildings[game.buildings.count-1].position.x = convertedLocation.x
                }
            }
        }
        
        @IBAction func makeTheBlock(_ sender: Any) {
            if !game.holding {
                game.createBlock(position: CGPoint(x: game.crane.position.x, y: game.crane.position.y-100), txture: SKTexture(image: UIImage(named: "street")!), sizex: 200, sizey: 100)
            }
        }
        
        @IBAction func lettapLocationsenderlocationinviewlongPressAction(_ sender: UILongPressGestureRecognizer) {
            let tapLocation = sender.location(in: view)
            let touchLocation = sender.location(in: view)
            if let scene = game.view?.scene {
                let convertedLocation = scene.convertPoint(fromView: touchLocation)
                
                game.crane.position.x = convertedLocation.x
            }
        }
        
        func blockClicked(buttonClicked: Int){
            
            
            
        }
        
        func updateBlocks(){
//            for i in 0..<randomBlockArray.count{
//                let image = UIImage(named: randomBlockArray[i].imageID)
//                image?.draw(in: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
//                buttonArray[i].setTitle("", for: .normal)
//                buttonArray[i].setImage(image, for: .normal)
//                
//                
//            }
            
        }
        
        
        
    }
