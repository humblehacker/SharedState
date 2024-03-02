import ComposableArchitecture
import SwiftUI

public struct ChainedActionsView: View {
    @State var store: StoreOf<ChainedActions>
    @State var text: String

    public init(store: StoreOf<ChainedActions>) {
        self.store = store
        self.text = ""
    }

    public var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter an integer value", text: $store.inputText)
                
                Button("Request Confirmation") {
                    store.send(.confirmationRequested)
                }
                
                Text(store.text)
                    .onAppear { store.send(.onAppear) }
                    .onDisappear { store.send(.onDisappear) }
            }
            .padding(40)
            .alert(
                item: $store.scope(
                    state: \.destination?.confirm,
                    action: \.destination.confirm
                )
            ) { store in
                Alert(
                    title: Text("Confirm?"),
                    dismissButton: .default(
                        Text("OK"),
                        action: { store.send(.delegate(.confirmed)) }
                    )
                )
            }
        }
    }
}
