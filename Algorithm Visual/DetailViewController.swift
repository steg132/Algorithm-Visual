//
//  DetailViewController.swift
//  Algorithm Visual
//
//  Created by Ryan Schumacher on 11/23/16.
//  Copyright © 2016 Schumacher. All rights reserved.
//

import UIKit
import SpriteKit

class DetailViewController: UIViewController {

    @IBOutlet var spriteView: SKView!

    var scene: SKScene? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        guard isViewLoaded, let scene = self.scene else {
            return
        }

        spriteView.presentScene(scene)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

}
