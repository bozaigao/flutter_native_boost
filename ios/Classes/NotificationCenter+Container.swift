//
//  NotificationCenter+Container.swift
//
//

import Foundation

public extension ContainerExtension where ExtendedType: NotificationCenter {
    
    // post notification to flutter engine
    // Flutter 可以通过 ContainerNotificationListener 来监听
    static func post(name: String, object arguments: Any? = nil) {
        Container.default.postNotification(name, arguments: arguments)
    }
}
