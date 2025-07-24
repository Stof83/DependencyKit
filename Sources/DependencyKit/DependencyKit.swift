//
//  DependencyKit.swift
//
//  Created by El Mostafa El Ouatri on 07/07/23.
//

import SwiftUI

/**
 A property wrapper that provides dependency injection using `@State` semantics for non-observable types.

 Use this when the injected type doesn't conform to `ObservableObject` and doesn't require observation or updates.
 - Important: The `DependencyContainer` must be properly configured before using this property wrapper.
 */
@MainActor
@propertyWrapper
public struct InjectedState<T>: DynamicProperty where T: AnyObject {
    @State private var value: T

    public var wrappedValue: T {
        value
    }

    public var projectedValue: Binding<T> {
        $value
    }

    /**
     Initializes the property wrapper by resolving the dependency from the container.
     
     - Precondition: `DependencyContainer.shared.resolve(T.self)` must not return nil.
     */
    public init() {
        _value = State(initialValue:  DependencyContainer.shared.resolve(T.self)!)
    }
}


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
    public init() {
        _model = StateObject(initialValue: DependencyContainer.shared.resolve(T.self)!)
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
    public init() {
        value = DependencyContainer.shared.resolve(T.self)!
    }
    
    /**
     Initializes the property wrapper and injects the dependency.

     - Parameter keyPath: The key path for retrieving the dependency.
    */
    public init(_ keyPath: WritableKeyPath<DependencyValues, T>) {
        value = DependencyContainer.shared.resolve(keyPath)
    }
}

