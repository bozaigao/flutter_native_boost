//
//  Options.swift
//
//

import Foundation

public struct Options {
    
    let raw: [String: Any]?
    
    init(_ value: [String: Any]?) {
        raw = value
    }
    
    public var animated: Bool {
        return get(key: "_container.animated", defaultValue: true)
    }
    
    public var present: Bool {
        return get(key: "_container.present", defaultValue: false)
    }
    
    public var isFlutterRoute: Bool {
        return get(key: "_container.flutter", defaultValue: false)
    }
    
    public func get<T>(key: String, defaultValue: T) -> T {
        return raw?[key] as? T ?? defaultValue
    }
}
