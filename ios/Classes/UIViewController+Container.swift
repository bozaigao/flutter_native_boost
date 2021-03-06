//
//  UIViewController+Container.swift
//
//

import UIKit

private struct AssociatedKeys {
    static var CallbackName = "container_CallbackName"
    static var DeallocatorName = "container_DeallocatorName"
}

public typealias CallbackToken = UUID

extension UIViewController {
    internal var callbackToken: CallbackToken? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.CallbackName) as? CallbackToken
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.CallbackName, newValue as CallbackToken?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension ContainerExtension where ExtendedType: UIViewController {
           
    static func automaticallyCallbackNullToFlutter() {
        swizzle(UIViewController.self, #selector(UIViewController.viewDidLoad), #selector(UIViewController.container_viewDidLoad))
    }
        
    var isModal: Bool {
        if let index = type.navigationController?.viewControllers.firstIndex(of: type), index > 0 {
            return false
        } else if type.presentingViewController != nil {
            if let parent = type.parent, !(parent is UINavigationController || parent is UITabBarController) {
               return false
            }
            return true
        } else if let navController = type.navigationController, navController.presentingViewController?.presentedViewController == navController {
            return true
        } else if type.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
   internal var callbackToken: CallbackToken? {
        return type.callbackToken
    }
    
    func enableCallback(with token: CallbackToken) {
        if (type.callbackToken != nil && type.callbackToken == token) {
            debugPrint("⚠️ [flutter_native_boost] update callback token will be lost callback.")
        }
        type.callbackToken = token
    }
       
    /// It's guaranteed to only be called once.
    ///
    func callback(result: Any?) {
        if (type.callbackToken != nil) {
            Container.callback(type.callbackToken, result: result)
            // 只回调一次
            type.callbackToken = nil
        }
    }
    
    func dismiss(withResult result: Any?, animated flag: Bool, completion: (() -> Void)? = nil) {
        type.fa.callback(result: result)
        type.dismiss(animated: flag, completion: completion)
    }
}

final class Deallocator {

    var closure: () -> Void

    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    deinit {
        closure()
    }
}

extension UIViewController {
    
    @objc fileprivate func container_viewDidLoad() {
        
        let token = callbackToken
        let deallocator = Deallocator {
            // 如果是滑动返回，或者点击左上角back键返回 则需要告诉flutter 没有返回值
            Container.callback(token, result: nil)
        }
        
        objc_setAssociatedObject(self, &AssociatedKeys.DeallocatorName, deallocator, .OBJC_ASSOCIATION_RETAIN)
        
        container_viewDidLoad()
    }
}
