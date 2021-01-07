//
//  NoNavigationBarViewController.swift
//  Runner
//
//

import UIKit
import flutter_native_boost

class NoNavigationBarViewController: BaseViewController, ContainerNavigationBarHiddenProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func onTabBack(sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
}
