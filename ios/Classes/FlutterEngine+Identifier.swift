//
//  FlutterEngine+Identifier.swift
//
//

import Flutter

private struct AssociatedKeys {
    static var IdentifierKeyName = "container_IdentifierKeyName"
}

extension ContainerExtension where ExtendedType: FlutterEngine {
    
    internal var id: Int? {
        get {
            return objc_getAssociatedObject(UIViewController.self, &AssociatedKeys.IdentifierKeyName) as? Int
        }
        nonmutating set {
            if let newValue = newValue {
                objc_setAssociatedObject(UIViewController.self, &AssociatedKeys.IdentifierKeyName, newValue as Int?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func generateNewId() -> Int {
        id = (id ?? 0) + 1
        return id!
    }
}

extension FlutterEngine: ContainerExtended { }
