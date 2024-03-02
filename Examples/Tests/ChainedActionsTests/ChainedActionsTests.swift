import ComposableArchitecture
@testable import ChainedActions
import XCTest

final class ChainedActionsTests: XCTestCase {

    @MainActor
    func testPublisher() async {
        let store = TestStore(initialState: ChainedActions.State()) {
            ChainedActions()
        } withDependencies: {
            $0.mainQueue = .immediate
            $0.uuid = .incrementing
        }

        await store.send(.onAppear)

        await store.send(.confirmationRequested) {
            $0.destination = .confirm(Confirm.State())
        }

        await store.send(\.destination.confirm.delegate.confirmed)

        await store.receive(.confirmed)

        await store.receive(\.binding) {
            $0.inputText = "123"
            $0.value = 123
        }

        await store.receive(\.valueUpdated, 123) {
            $0.text = "123"
        }

        await store.send(.onDisappear)

        await store.finish()
    }
}
