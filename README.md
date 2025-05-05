# DependencyKit

[![Swift Version](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Stof83/DependencyKit/blob/main/LICENSE)

This is a lightweight, flexible, and production-ready **Dependency Injection (DI)** system for Swift and SwiftUI apps, inspired by modern patterns from Clean Architecture and Domain-Driven Design. It supports both **type-based** and **key-path-based** registrations and resolutions, making it ideal for modular, scalable, and testable applications.

## Features

- ✅ Type-safe dependency resolution
- ✅ KeyPath-based scoped dependency access
- ✅ Property wrappers for SwiftUI and non-SwiftUI types
- ✅ Clean API for registration and usage
- ✅ Seamless integration with `@StateObject` and `@ObservedObject`
- ✅ Support for both struct-based and class-based models

---

## Installation

Use Swift Package Manager:

```swift
// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "YourPackageName",
    dependencies: [
        .package(url: "https://github.com/Stof83/DependencyKit.git", from: "1.0.0")
    ],
    targets: [
        .target(
                name: "YourTargetName",
                dependencies: [
                    .product(name: "DependencyKit", package: "DependencyKit")
                ]
        )
    ]
)
```
---

## Usage

### Step 1: Define your Dependencies

```swift
class ViewModel1: ObservableObject {}
class ViewModel2: NSObject {}
```

### Step 2: Register Dependencies

You can register dependencies by **type** or by **key path**.

#### Register by KeyPath

Extend `DependencyValues` to define scoped keys:

```swift
extension DependencyValues {
    var baseURL: URL {
        get { resolve(\.baseURL) }
        set { register(newValue, for: \.baseURL) }
    }
}
```

Register the dependency:

```swift
let baseURL = URL(string: "https://api.example.com")!
let dependencyManager = DependencyManager()
dependencyManager.register(baseURL, for: \.baseURL)
```

#### Register by Type

```swift
let viewModel1 = ViewModel1()
let viewModel2 = ViewModel2()

let dependencyManager = DependencyManager()
dependencyManager.register(dependencies: [
    (viewModel1, ViewModel1.self),
    (viewModel2, ViewModel2.self)
])
```

---

## Injecting Dependencies

### In SwiftUI Views

```swift
struct MyView: View {
    @InjectedStateObject var viewModel1: ViewModel1
    @Dependency(\.baseURL) var baseURL: URL

    var body: some View {
        VStack {
            Text("Base URL: \(baseURL.absoluteString)")
            Text("ViewModel1 class: \(String(describing: type(of: viewModel1)))")
        }
    }
}
```

### In Non-SwiftUI Classes

```swift
class Service {
    @InjectedViewModel var viewModel2: ViewModel2

    func printType() {
        print("Injected ViewModel2 type: \(type(of: viewModel2))")
    }
}
```

---

## Updating or Removing Dependencies

```swift
// Replace baseURL at runtime
dependencyManager.register(URL(string: "https://new.api.com")!, for: \.baseURL)

// Remove a dependency by type
dependencyManager.remove(ViewModel1.self)
```

---

## Testing Tips

- Register mock implementations for unit tests.
- Use a custom `DependencyContainer` instance for isolation.

```swift
let testContainer = DependencyContainer()
testContainer.register(MockService() as ServiceProtocol, for: ServiceProtocol.self)
```

---

## License

DependencyKit is released under the MIT license. [See LICENSE](https://github.com/Stof83/DependencyKit/blob/main/LICENSE) for details.
