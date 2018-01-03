//
//  SinglePlayerViewController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 30/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol SinglePlayerViewControllerDelegate: class {
    func startQuickGame()
    func closeSinglePlayerWindow()
}

class SinglePlayerViewController: NSViewController {
    weak var delegate: SinglePlayerViewControllerDelegate?
    override var nibName: NSNib.Name {
        return NSNib.Name("SinglePlayerViewController")
    }
    @IBOutlet weak var quickGameButton: NSTextField!

    @IBAction func quickGameButtonPressed(_ sender: Any) {
        delegate?.startQuickGame()
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate?.closeSinglePlayerWindow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quickGameButton.toolTip = "An avarage difficulty game on a medium sized map"
        self.view.backgroundColor = NSColor.black
    }
}
