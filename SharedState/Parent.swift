import ComposableArchitecture
import SwiftUI

@Reducer
struct Parent {
    @ObservableState
    struct State: Equatable {
        @Shared var value: Int
        var child: Child.State

        init(value: Int = 0) {
            self._value = Shared(value)
            self.child = .init(text: "", value: _value)
        }
    }

    enum Action: Equatable {
        case child(Child.Action)
        case incrementValue
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.child, action: \.child) { Child() }

        Reduce { state, action in
            switch action {
            case .child:
                return .none

            case .incrementValue:
                state.value += 1
                return .none
            }
        }
    }
}

struct ParentView: View {
    @State var uuid = UUID()
    let store: StoreOf<Parent>

    var body: some View {
        VStack {
            ChildView(store: store.scope(state: \.child, action: \.child))
            Button("Increment") { store.send(.incrementValue) }
        }
        .padding()
    }
}

#Preview {
    ParentView(store: .init(initialState: .init()) {
        Parent()
    })
}
