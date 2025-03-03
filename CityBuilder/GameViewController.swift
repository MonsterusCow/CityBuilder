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
    
    static var game : GameScene!
    
    
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
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
        
        craneButNot.center.x = tapLocation.x
        AppData.game.crane.position.x = tapLocation.x
    }
    
    
    
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        
        craneButNot.center.x = tapLocation.x
    }
    
    
    @IBAction func lettapLocationsenderlocationinviewlongPressAction(_ sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        
        craneButNot.center.x = tapLocation.x
    }
    
}
