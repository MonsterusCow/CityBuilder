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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    @IBOutlet weak var craneButNot: UIButton!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        
        
    }
    
    
    
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        let touchLocation = sender.location(in: view)
            if let scene = game.view?.scene {
            let convertedLocation = scene.convertPoint(fromView: touchLocation)

            game.crane.position.x = convertedLocation.x
        }
    }
    
    
    @IBAction func lettapLocationsenderlocationinviewlongPressAction(_ sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        
        craneButNot.center.x = tapLocation.x
    }
    
}
