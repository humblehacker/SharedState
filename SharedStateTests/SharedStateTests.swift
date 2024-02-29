import ComposableArchitecture
@testable import SharedState
import XCTest

final class SharedStateTests: XCTestCase {

    @MainActor
    func testPublisher() async {
        let store = TestStore(initialState: Parent.State()) {
            Parent()
        }

        await store.send(.child(.onAppear))

        await store.send(.incrementValue) {
            $0.value = 1
        }

        await store.receive(\.child.valueUpdated) {
            $0.child.text = "1"
        }

        await store.send(.child(.onDisappear))

        await store.finish()
    }
}
