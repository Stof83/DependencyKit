//
//  DependencyContainer.swift
//
//  Created by El Mostafa El Ouatri on 07/07/23.
//

import Foundation

/**
 A  container that manages dependencies using type-based and key-path-based registration.

 This container stores and resolves dependencies either by type or by key path, allowing
 flexibility in dependency management.
*/
final class DependencyContainer {
    private var dependenciesByType: [ObjectIdentifier: Any] = [:]
    private var dependenciesByKeyPath: [PartialKeyPath<DependencyValues>: Any] = [:]

    init() {}

    /**
     Registers a dependency for a given type.

     - Parameters:
       - dependency: The instance to be registered.
       - type: The type of the dependency.
    */
    func register<T>(_ dependency: T, for type: T.Type) {
        dependenciesByType[ObjectIdentifier(type)] = dependency
    }

    /// Registers multiple dependencies at once.
    ///
    /// - Parameter dependencies: An array of tuples containing the dependency instances and their corresponding types.
    func register(_ dependencies: [(Any, Any.Type)]) {
        for (dependency, type) in dependencies {
            let key = ObjectIdentifier(type)
            self.dependenciesByType[key] = dependency
        }
    }
    /**
     Registers a dependency for a specific key path.

     - Parameters:
       - dependency: The instance to be registered.
       - keyPath: The key path associated with the dependency.
    */
    func register<T>(_ dependency: T, for keyPath: WritableKeyPath<DependencyValues, T>) {
        dependenciesByKeyPath[keyPath] = dependency
    }

    /**
     Resolves a dependency using its type.

     - Parameter type: The type of the dependency.
     - Returns: The resolved dependency instance or `nil` if not found.
    */
    func resolve<T>(_ type: T.Type) -> T? {
        dependenciesByType[ObjectIdentifier(type)] as? T
    }

    /**
     Resolves a dependency using its key path.

     - Parameter keyPath: The key path of the dependency.
     - Returns: The resolved dependency instance or a default value if not found.
    */
    func resolve<T>(_ keyPath: WritableKeyPath<DependencyValues, T>) -> T {
        guard let value = dependenciesByKeyPath[keyPath] as? T else {
            fatalError("Dependency not found for \(keyPath)")
        }
        return value
    }

    /**
     Removes a dependency by type.

     - Parameter type: The type of the dependency to remove.
    */
    func remove<T>(_ type: T.Type) {
        dependenciesByType.removeValue(forKey: ObjectIdentifier(type))
    }

    /**
     Removes a dependency by key path.

     - Parameter keyPath: The key path of the dependency to remove.
    */
    func remove<T>(_ keyPath: WritableKeyPath<DependencyValues, T>) {
        dependenciesByKeyPath.removeValue(forKey: keyPath)
    }
}
