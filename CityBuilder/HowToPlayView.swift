//
//  HowToPlayView.swift
//  CityBuilder
//
//  Created by PETER MICKLE on 3/14/25.
//

import Foundation
import UIKit

class HowToPlayView: UIViewController{
    
    
    @IBOutlet weak var tutorialText1: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialText1.text = "-Click blocks to pick them up  \n -Drag blocks and aling them with other blocks for points \n -make sure you drop blocks quickly because you can't hold them forever \n -press the edges of the screen to move the camera \n -make sure to make the point quotas and dont knock over your buildings"
    }
    
    
    
    
}
