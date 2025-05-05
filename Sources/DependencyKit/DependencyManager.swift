//
//  DependencyManager.swift
//  DependencyKit
//
//  Created by El Mostafa El Ouatri on 10/03/25.
//

import Foundation

/// The `DependencyManager` class is a concrete implementation of the `DependencyManagerProtocol` and provides access to dependencies for the application. It acts as a central repository for managing and providing instances of various dependencies throughout the application.
public final class DependencyManager: NSObject {

    private let container = DependencyContainer()

    /// Registers an array of dependencies with the `DependencyManager`.
    ///
    /// - Parameter dependencies: An array of `(Any, Any.Type)` tuples representing the dependencies to be registered.
    public func register(dependencies: [(Any, Any.Type)]) {
        container.register(dependencies)
    }
    
    /**
     Registers multiple dependencies using key-path-based registration.

     - Parameter dependencies: An array of tuples containing instances and their key paths.
    */
    public func register<T>(dependencies: [(T, WritableKeyPath<DependencyValues, T>)]) {
        for (dependency, keyPath) in dependencies {
            container.register(dependency, for: keyPath)
        }
    }


    /// Registers a single dependency with the `DependencyManager`.
    ///
    /// - Parameters:
    ///   - dependency: The dependency instance to be registered.
    ///   - type: The type of the dependency.
    public func register<T>(_ dependency: T, for type: T.Type) {
        container.register(dependency, for: type)
    }
    
    /// Registers a single dependency with the `DependencyManager`.  using key-path-based registration.
    ///
    /// - Parameters:
    ///   - dependency: The dependency instance to be registered.
    ///   - keyPath: The key path of the dependency.
    public func register<T>(_ dependency: T, for keyPath: WritableKeyPath<DependencyValues, T>) {
        container.register(dependency, for: keyPath)
    }

    /// Removes a specific dependency from the `DependencyManager`.
    ///
    /// - Parameter type: The type of the dependency to remove.
    public func remove<T>(_ type: T.Type) {
        container.remove(type)
    }
}

