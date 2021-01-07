//
//  ContainerFlutterViewController.swift
//
//

import UIKit
import Flutter

open class ContainerFlutterViewController: FlutterViewController, UINavigationControllerDelegate {
    
    public let name: String
    public let arguments: Any?
    
    let backgroundClear: Bool
    
    let id: Int
    
    private var callback: ((Any?) -> ())?
    
    private var isShowing = false
    private weak var previousFlutterViewController: ContainerFlutterViewController?
    private var swipeBackIsEnable = true
        
    public init(_ name: String, arguments: Any? = nil, backgroundClear: Bool = false, engine: FlutterEngine? = nil, callback: ((Any?) -> ())? = nil) {
        self.name = name
        self.arguments = arguments
        self.backgroundClear = backgroundClear
        self.callback = callback
        
        guard let rawEngine = engine ?? Container.default.engine else {
            fatalError("Container engine must not be nil")
        }
                
        previousFlutterViewController = rawEngine.viewController as? ContainerFlutterViewController
        rawEngine.viewController = nil
        
        self.id = rawEngine.fa.generateNewId()
        super.init(engine: rawEngine, nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        isShowing = true
        createFlutterPage()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createFlutterPage() {
        Container.sendPageState(.create(name, arguments, id, backgroundClear)) { _ in }
    }
    
    weak var interactivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?
        
    public func disableHorizontalSwipePopGesture(disable: Bool) {
        //
        // 这里不能无脑设置为 !disable 具体原因：
        //
        // ref: https://stackoverflow.com/questions/36503224/ios-app-freezes-on-pushviewcontroller
        //
        if ((navigationController?.viewControllers.count ?? 0) > 1) {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = !disable
        }
    }
    
    public func callbackValueToCreator(_ value: Any?) {
        if let cb = callback {
          cb(value)
          callback = nil
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundClear ? .clear : .white
        navigationController?.delegate = self
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        engine?.viewController = self
        isShowing = true
        Container.sendPageState(.show(id)) { _ in }
        super.viewWillAppear(animated)
        view.backgroundColor = backgroundClear ? .clear : .white
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        interactivePopGestureRecognizerDelegate = navigationController?.interactivePopGestureRecognizer?.delegate
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let isEnabled = navigationController?.interactivePopGestureRecognizer?.isEnabled ?? false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if (isEnabled && (navigationController?.viewControllers.count ?? 0) > 1) {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        super.viewDidAppear(animated)
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if (navigationController.viewControllers.count > 1) {
            navigationController.interactivePopGestureRecognizer?.isEnabled = navigationController.interactivePopGestureRecognizer?.isEnabled ?? false
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        if let p = previousFlutterViewController, p.isShowing {
            Container.refreshViewController(p)
        }
        super.viewWillDisappear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        //
        // ref: https://stackoverflow.com/questions/36503224/ios-app-freezes-on-pushviewcontroller
        //
        navigationController?.interactivePopGestureRecognizer?.delegate = interactivePopGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (navigationController?.viewControllers.count ?? 0) > 1
        
        isShowing = false
//        Container.sendPageState(.hiden(id)) { r in
//            let succeed = r as? Bool ?? false
//            debugPrint("id: \(id) send pageState `hiden` \(succeed ? "succeed" : "failed")")
//        }
        super.viewDidDisappear(animated)
    }
    
    // 处理有多个 FlutterViewController的情况
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (Container.default.currentFlutterViewController != self) {
            Container.refreshViewController(self)
        }
        super.touchesBegan(touches, with: event)
    }
    
    deinit {
        Container.sendPageState(.dealloc(id)) { _ in }
        debugPrint("container flutter deinit \(name) \(id)")
    }
}
