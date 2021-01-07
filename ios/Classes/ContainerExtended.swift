//
//  ContainerExtend.swift
//
//

import Foundation

public struct ContainerExtension<ExtendedType> {
    /// Stores the type or meta-type of any extended type.
    public private(set) var type: ExtendedType

    /// Create an instance from the provided value.
    ///
    /// - Parameter type: Instance being extended.
    public init(_ type: ExtendedType) {
        self.type = type
    }
}

/// Protocol describing the `fa` extension points for Container extended types.
public protocol ContainerExtended {
    /// Type being extended.
    associatedtype ExtendedType

    /// Static Container extension point.
    static var fa: ContainerExtension<ExtendedType>.Type { get set }
    /// Instance Container extension point.
    var fa: ContainerExtension<ExtendedType> { get set }
}

public extension ContainerExtended {
    /// Static Container extension point.
    static var fa: ContainerExtension<Self>.Type {
        get { ContainerExtension<Self>.self }
        set {}
    }

    /// Instance Container extension point.
    var fa: ContainerExtension<Self> {
        get { ContainerExtension(self) }
        set {}
    }
}

extension UIViewController: ContainerExtended { }
extension NotificationCenter: ContainerExtended { }
