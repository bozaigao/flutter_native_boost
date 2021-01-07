//
//  Tab2ViewController.swift
//  Runner
//
//

import UIKit
import flutter_native_boost

class Tab2ViewController: BaseViewController, ContainerNavigationBarHiddenProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let vc = ContainerFlutterViewController("home")
        
        vc.willMove(toParent: self)
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        vc.view.frame = view.frame;
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleWidth]
    }
}
