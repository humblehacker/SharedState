import ComposableArchitecture
import SwiftUI

@Reducer
struct Parent {
    @ObservableState
    struct State: Equatable {
        @Shared var value: Int
        var children: IdentifiedArrayOf<Child.State>

        init(value: Int = 0) {
            @Dependency(\.uuid) var uuid
            self._value = Shared(value)
            self.children = [
                .init(id: uuid(), text: "0", value: _value),
                .init(id: uuid(), text: "0", value: _value),
                .init(id: uuid(), text: "0", value: _value),
                .init(id: uuid(), text: "0", value: _value)
            ]
        }
    }

    enum Action: Equatable {
        case children(IdentifiedActionOf<Child>)
        case incrementValue
    }


    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .children:
                return .none

            case .incrementValue:
                state.value += 1
                return .none
            }
        }
        .forEach(\.children, action: \.children) { Child() }
    }
}

struct ParentView: View {
    @State var uuid = UUID()
    let store: StoreOf<Parent>

    var body: some View {
        VStack {
            HStack {
                ForEach(store.scope(state: \.children, action: \.children)) { store in
                    ChildView(store: store)
                }
            }
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
