import ComposableArchitecture
@testable import SharedState
import XCTest

final class SharedStateTests: XCTestCase {

    @MainActor
    func testPublisher() async {
        let store = TestStore(initialState: ContentReducer.State()) {
            ContentReducer()
        }

        await store.send(.incrementValue) {
            $0.value = 1
        }

        await store.receive(.valueUpdated(1)) {
            $0.text = "1"
        }
    }
}
