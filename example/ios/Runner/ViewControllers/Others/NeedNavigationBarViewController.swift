//
//  NeedNavigationBarViewController.swift
//  Runner
//
//

import UIKit

class NeedNavigationBarViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
