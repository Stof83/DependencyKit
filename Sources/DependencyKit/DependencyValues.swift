//
//  DependencyValues.swift
//  DependencyKit
//
//  Created by El Mostafa El Ouatri on 11/03/25.
//

import Foundation

/**
 A struct that holds dependency values and allows retrieval using key paths.

 This struct enables dependency resolution through key paths, allowing multiple instances
 of the same type to be registered and accessed distinctly.

 - Example:
 ```swift
 @Dependency(\.baseURL) var baseURL: URL
 @Dependency(\.dataURL) var dataURL: URL
 */
public struct DependencyValues {
    private let container = DependencyContainer.shared
    
    /// Registers a dependency for a key path.
    ///
    /// - Parameters:
    ///   - dependency: The instance to register.
    ///   - keyPath: The key path the dependency is stored under.
    public func register<T>(_ dependency: T, for keyPath: WritableKeyPath<DependencyValues, T>) {
        container.register(dependency, for: keyPath)
    }

    /// Resolves the dependency for a key path, falling back to a default when none is registered.
    ///
    /// Use it in a key's getter so a missing registration never crashes:
    /// ```swift
    /// extension DependencyValues {
    ///     public var userCoordinate: () -> CLLocationCoordinate2D? {
    ///         get { resolve(\.userCoordinate, default: { nil }) }
    ///         set { register(newValue, for: \.userCoordinate) }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - keyPath: The key path the dependency is stored under.
    ///   - defaultValue: The value returned when nothing is registered for `keyPath`.
    /// - Returns: The registered dependency, or `defaultValue` if not found.
    public func resolve<T>(_ keyPath: WritableKeyPath<DependencyValues, T>, default defaultValue: @autoclosure () -> T) -> T {
        container.resolve(keyPath, default: defaultValue)
    }

    /// Resolves the dependency for a key path.
    ///
    /// Optional dependencies resolve to `nil` when not registered; any other missing dependency
    /// terminates the app. Prefer ``resolve(_:default:)``.
    ///
    /// - Parameter keyPath: The key path the dependency is stored under.
    /// - Returns: The registered dependency, or `nil` for an unregistered optional dependency.
    @available(*, deprecated, message: "Declare a default with resolve(_:default:) — a missing key crashes otherwise.")
    public func resolve<T>(_ keyPath: WritableKeyPath<DependencyValues, T>) -> T {
        container.resolve(keyPath)
    }
}
