//
//  TabSplitViewController.swift
//  Runner
//
//

import Foundation
import flutter_native_boost

class TabSplitViewController: UIViewController {
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = parent?.children.firstIndex(of: self), index == 0 {
            if let vc = children.first as? ContainerFlutterViewController {
                Container.refreshViewController(vc)
            }
        }
    }
    
}


