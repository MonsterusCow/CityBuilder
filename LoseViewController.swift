//
//  LoseViewController.swift
//  CityBuilder
//
//  Created by RYAN STARK on 3/19/25.
//

import UIKit

class LoseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            exit(0)
        }

    }
    


}
