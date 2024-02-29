import ComposableArchitecture
import SwiftUI

@Reducer
struct ContentReducer {
    @ObservableState
    struct State: Equatable {
        @Shared var value: Int
        var text: String

        init(value: Int = 0, text: String = "0") {
            self._value = Shared(value)
            self.text = text
        }
    }
    enum Action: Equatable {
        case incrementValue
        case task
        case valueUpdated(_ newValue: Int)
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementValue:
                state.value += 1
                return .none
            case .task:
                let publisher = state.$value.publisher.map { Action.valueUpdated($0) }
                return .publisher { publisher }

            case .valueUpdated(let newValue):
                state.text = "\(newValue)"
                return .none
            }
        }
    }
}

struct ContentView: View {
    @State var uuid = UUID()
    let store: StoreOf<ContentReducer>

    var body: some View {
        VStack {
            Text(store.text)
            Button("Increment") { store.send(.incrementValue) }
        }
        .padding()
        .task(id: uuid) { store.send(.task) }
    }
}

#Preview {
    ContentView(store: .init(initialState: .init()) {
        ContentReducer()
    })
}
