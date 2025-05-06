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
@MainActor
public struct DependencyValues {
    private let container = DependencyContainer.shared
    
    public func register<T>(_ dependency: T, for keyPath: WritableKeyPath<DependencyValues, T>) {
        container.register(dependency, for: keyPath)
    }

    public func resolve<T>(_ keyPath: WritableKeyPath<DependencyValues, T>) -> T {
        container.resolve(keyPath)
    }
}
