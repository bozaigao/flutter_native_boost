//
//  Native2FlutterViewController.swift
//  Runner
//
//

import UIKit
import flutter_native_boost

class Native2FlutterViewController: BaseViewController {

    
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onTap(sender: UIButton) {
        
        let vc = FPage.native2flutter.flutterViewController { [weak self] r in
            self?.label.text = r.debugDescription
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTap1(sedner: UIButton) {
        
        let vc = ContainerFlutterViewController("transparent_flutter", backgroundClear: true)
        
        navigationController?.present(vc, animated: false, completion: nil)
    }
}
