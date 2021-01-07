//
//  Flutter2NativeViewController.swift
//  Runner
//
//

import UIKit
import flutter_native_boost

class Flutter2NativeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iOS Native (F2N)"
    }
    
    @IBAction func touchPop(sender: UIButton) {
        
        let r = ["date": Date().description]
        
        if (fa.isModal) {
            fa.dismiss(withResult: r, animated: true)
        } else {
            navigationController?.fa.popViewController(withResult: r, animated: true)
        }
    }
}
