import ComposableArchitecture
import SwiftUI

@Reducer
struct Child {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: UUID
        var text: String
        @Shared var value: Int
    }

    enum Action: Equatable {
        case onAppear
        case onDisappear
        case valueUpdated(_ newValue: Int)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .valueUpdated(let newValue):
                state.text = "\(newValue)"
                return .none

            case .onAppear:
                let publisher = state.$value.publisher.map { Action.valueUpdated($0) }
                return .publisher { publisher }
                    .cancellable(id: CancelID.valuePublisher, cancelInFlight: true)

            case .onDisappear:
                return .cancel(id: CancelID.valuePublisher)
            }
        }
    }
}

enum CancelID { case valuePublisher }

struct ChildView: View {
    let store: StoreOf<Child>

    var body: some View {
        Text(store.text)
            .onAppear { store.send(.onAppear) }
            .onDisappear { store.send(.onDisappear) }
    }
}
