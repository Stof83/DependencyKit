//
//  DependencyKit.swift
//
//  Created by El Mostafa El Ouatri on 07/07/23.
//

import SwiftUI

/**
 A property wrapper that provides automatic dependency injection for an `ObservableObject`.
 
 Use this property wrapper to inject an `ObservableObject` model with dependencies resolved from the `DependencyContainer`.
 - Important: The `DependencyContainer` must be properly configured with the necessary dependencies before using this property wrapper.
 - Precondition: The `DependencyContainer.shared` must be a valid instance of `DependencyContainer` with resolved dependencies.
*/
@MainActor
@propertyWrapper
public struct InjectedStateObject<T>: DynamicProperty where T: ObservableObject {
    @StateObject private var model: T
    
    /// Retrieves the injected `ObservableObject` model.
    public var wrappedValue: T {
        get { model }
    }
    
    public var projectedValue: ObservedObject<T>.Wrapper {
        self.$model
    }
    
    /**
     Creates an instance of the property wrapper.
     
     The model is automatically injected with dependencies upon initialization.
     
     - Precondition: The `DependencyContainer.shared` must be a valid instance of `DependencyContainer` with resolved dependencies.
     */
    @MainActor
    public init() {
        _model = StateObject(wrappedValue: DependencyContainer.shared.resolve(T.self)!)
    }
}

/**
 A property wrapper that provides automatic dependency injection for a class-based model.

 Use this property wrapper to inject a class-based model with dependencies resolved from the `DependencyContainer`.
 - Important: The `DependencyContainer` must be properly configured with the necessary dependencies before using this property wrapper.
 - Precondition: The `DependencyContainer.shared` must be a valid instance of `DependencyContainer` with resolved dependencies.
*/
@propertyWrapper
public struct InjectedViewModel<T> where T: AnyObject {
    private var model: T
    
    /// Retrieves the injected class-based model.
    public var wrappedValue: T {
        get { model }
        set { model = newValue }
    }
    
    public var projectedValue: T {
        model
    }
    
    /**
     Creates an instance of the property wrapper.
     
     The model is automatically injected with dependencies upon initialization.
     
     - Precondition: The `DependencyContainer.shared` must be a valid instance of `DependencyContainer` with resolved dependencies.
     */
    @MainActor
    public init() {
        model = DependencyContainer.shared.resolve(T.self)!
    }
}

/**
 A property wrapper that provides automatic dependency injection for any type.

 Use this property wrapper to inject a class-based model with dependencies resolved from the `DependencyContainer`.
 - Important: The `DependencyContainer` must be properly configured with the necessary dependencies before using this property wrapper.
 - Precondition: The `DependencyContainer.shared` must be a valid instance of `DependencyContainer` with resolved dependencies.
*/

@propertyWrapper
public struct Dependency<T> {
    private var value: T
    
    /// Retrieves the injected class-based model.
    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    public var projectedValue: T {
        value
    }
    
    /**
     Creates an instance of the property wrapper.
     
     The model is automatically injected with dependencies upon initialization.
     
     - Precondition: The `DependencyContainer.shared` must be a valid instance of `DependencyContainer` with resolved dependencies.
     */
    @MainActor
    public init() {
        value = DependencyContainer.shared.resolve(T.self)!
    }
    
    /**
     Initializes the property wrapper and injects the dependency.

     - Parameter keyPath: The key path for retrieving the dependency.
    */
    @MainActor
    public init(_ keyPath: WritableKeyPath<DependencyValues, T>) {
        value = DependencyContainer.shared.resolve(keyPath)
    }
}

