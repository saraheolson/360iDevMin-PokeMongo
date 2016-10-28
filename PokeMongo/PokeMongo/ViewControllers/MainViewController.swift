//
//  MainViewController.swift
//  PokeMongo
//
//  Created by Floater on 8/27/16.
//  Copyright © 2016 SarahEOlson. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the navigation bar
        self.navigationController?.navigationBar.isHidden = true
    }
}
