import ComposableArchitecture
@testable import DistributedUpdates
import XCTest

final class DistributedUpdatesTests: XCTestCase {

    @MainActor
    func testPublisher() async {
        let store = TestStore(initialState: Parent.State()) {
            Parent()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        await store.send(.children(.element(id: UUID(0), action: .onAppear)))
        await store.send(.children(.element(id: UUID(1), action: .onAppear)))
        await store.send(.children(.element(id: UUID(2), action: .onAppear)))
        await store.send(.children(.element(id: UUID(3), action: .onAppear)))

        await store.send(.incrementValue) {
            $0.value = 1
        }

        await store.receive(\.children[id: UUID(0)].valueUpdated) {
            $0.children[id: UUID(0)]?.text = "1"
        }

        await store.receive(\.children[id: UUID(1)].valueUpdated) {
            $0.children[id: UUID(1)]?.text = "1"
        }

        await store.receive(\.children[id: UUID(2)].valueUpdated) {
            $0.children[id: UUID(2)]?.text = "1"
        }

        await store.receive(\.children[id: UUID(3)].valueUpdated) {
            $0.children[id: UUID(3)]?.text = "1"
        }

        await store.send(.children(.element(id: UUID(0), action: .onDisappear)))
        await store.send(.children(.element(id: UUID(1), action: .onDisappear)))
        await store.send(.children(.element(id: UUID(2), action: .onDisappear)))
        await store.send(.children(.element(id: UUID(3), action: .onDisappear)))

        await store.finish()
    }
}
