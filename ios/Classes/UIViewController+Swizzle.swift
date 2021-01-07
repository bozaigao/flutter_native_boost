//
//  NavigationController.swift
//
//

import UIKit

let swizzle: (AnyClass, Selector, Selector) -> () = { fromClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(fromClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(fromClass, swizzledSelector)
        else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

// 当前 ViewController 需要隐藏navigationBar时，需遵循此协议,此外如果是rootVC，则需要单独设置navigationBarHidden
public protocol ContainerNavigationBarHiddenProtocol {}

extension ContainerFlutterViewController: ContainerNavigationBarHiddenProtocol { }

public extension ContainerExtension where ExtendedType: UINavigationController {
        
    static func automaticallyHandleNavigationBarHidden() {
        swizzle(UINavigationController.self, #selector(UINavigationController.pushViewController(_:animated:)), #selector(UINavigationController.container_pushViewController(_:animated:)))
        swizzle(UINavigationController.self, #selector(UINavigationController.popViewController(animated:)), #selector(UINavigationController.container_popViewController(animated:)))
        swizzle(UINavigationController.self, #selector(UINavigationController.popToViewController(_:animated:)), #selector(UINavigationController.container_popToViewController(_:animated:)))
        swizzle(UINavigationController.self, #selector(UINavigationController.popToRootViewController(animated:)), #selector(UINavigationController.container_popToRootViewController(animated:)))
    }
    
    @discardableResult
    func popViewController(withResult result: Any?, animated: Bool) -> UIViewController? {
        let vc = type.popViewController(animated: animated)
        vc?.fa.callback(result: result)
        return vc
    }
}

extension UINavigationController {

    @objc fileprivate func container_pushViewController(_ viewController: UIViewController, animated: Bool) {
        var formHidden = false
        var toHidden = false
        
        if let _ = viewControllers.last as? ContainerNavigationBarHiddenProtocol {
            formHidden = true
        }
        if let _ = viewController as? ContainerNavigationBarHiddenProtocol {
            toHidden = true
        }
        
        container_pushViewController(viewController, animated: animated)
        if formHidden != toHidden {
            setNavigationBarHidden(toHidden, animated: animated)
        }
    }
    
    @objc fileprivate func container_popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.count <= 1 {
            return nil
        }
        var formHidden = false
        var toHidden = false
        
        if let _ = viewControllers.last as? ContainerNavigationBarHiddenProtocol {
            formHidden = true
        }
        if let _ = viewControllers[viewControllers.count - 2] as? ContainerNavigationBarHiddenProtocol {
            toHidden = true
        }
        
        defer {
            if formHidden != toHidden {
                setNavigationBarHidden(toHidden, animated: animated)
            }
        }
        
        return container_popViewController(animated: animated)
    }
    
    @objc fileprivate func container_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if viewControllers.count <= 1 {
            return nil
        }
        var formHidden = false
        var toHidden = false
        
        if let _ = viewControllers.last as? ContainerNavigationBarHiddenProtocol {
            formHidden = true
        }
        
        if let _ = viewController as? ContainerNavigationBarHiddenProtocol {
            toHidden = true
        }
        
        defer {
            if formHidden != toHidden {
                setNavigationBarHidden(toHidden, animated: animated)
            }
        }
        
        return container_popToViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func container_popToRootViewController(animated: Bool) -> [UIViewController]? {
        if viewControllers.count <= 1 {
            return nil
        }
        var formHidden = false
        var toHidden = false
        
        if let _ = viewControllers.last as? ContainerNavigationBarHiddenProtocol {
            formHidden = true
        }
        if let _ = viewControllers.first as? ContainerNavigationBarHiddenProtocol {
            toHidden = true
        }
        
        defer {
            if formHidden != toHidden {
                setNavigationBarHidden(toHidden, animated: animated)
            }
        }
        return container_popToRootViewController(animated: animated)
    }
}
