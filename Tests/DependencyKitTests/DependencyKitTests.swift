import Foundation
import Testing

@testable import DependencyKit

// MARK: - Test Keys

private extension DependencyValues {
    var defaultedName: String {
        get { resolve(\.defaultedName, default: "fallback") }
        set { register(newValue, for: \.defaultedName) }
    }

    var defaultedProvider: () -> Int? {
        get { resolve(\.defaultedProvider, default: { nil }) }
        set { register(newValue, for: \.defaultedProvider) }
    }

    var optionalName: String? {
        get { DependencyContainer.shared.resolve(\.optionalName) }
        set { register(newValue, for: \.optionalName) }
    }

    var counter: Int {
        get { resolve(\.counter, default: 0) }
        set { register(newValue, for: \.counter) }
    }
}

// MARK: - Tests

@Suite(.serialized)
struct DependencyKitTests {
    private var container: DependencyContainer { .shared }

    @Test
    func missingKeyWithDefaultReturnsDefault() {
        container.remove(\.defaultedName)

        #expect(DependencyValues().defaultedName == "fallback")
    }

    @Test
    func registeredValueOverridesDefault() {
        container.register("registered", for: \.defaultedName)
        defer { container.remove(\.defaultedName) }

        #expect(DependencyValues().defaultedName == "registered")
    }

    @Test
    func missingOptionalKeyResolvesToNil() {
        container.remove(\.optionalName)

        #expect(DependencyValues().optionalName == nil)
    }

    @Test
    func dependencyWrapperUsesGetterDefaultForMissingKey() {
        container.remove(\.defaultedProvider)

        @Dependency(\.defaultedProvider) var provider

        #expect(provider() == nil)
    }

    @Test
    func dependencyWrapperResolvesRegisteredClosure() {
        container.register({ 42 }, for: \.defaultedProvider)
        defer { container.remove(\.defaultedProvider) }

        @Dependency(\.defaultedProvider) var provider

        #expect(provider() == 42)
    }

    @Test
    func concurrentRegisterAndResolveDoesNotCrash() async {
        container.remove(\.counter)
        defer { container.remove(\.counter) }

        await withTaskGroup(of: Void.self) { group in
            for iteration in 0..<1_000 {
                group.addTask {
                    if iteration.isMultiple(of: 2) {
                        DependencyContainer.shared.register(iteration, for: \.counter)
                    } else {
                        _ = DependencyValues().counter
                    }
                }
            }
        }

        #expect(DependencyValues().counter >= 0)
    }
}
