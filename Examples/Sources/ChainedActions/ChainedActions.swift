import ComposableArchitecture
import SwiftUI

@Reducer
public struct ChainedActions {
    @ObservableState
    public struct State: Equatable {
        var inputText: String
        var text: String
        @Shared var value: Int?
        @Presents var destination: Destination.State?

        public init(inputText: String = "", text: String = "", value: Int? = nil) {
            self.inputText = inputText
            self.text = text
            self._value = Shared(value)
            self.destination = nil
        }
    }

    public enum Action: BindableAction, Equatable {
        case confirmationRequested
        case confirmed
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case onDisappear
        case valueUpdated(_ newValue: Int?)
    }

    @Dependency(\.mainQueue) var mainQueue

    enum CancelID { case valuePublisher }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .confirmationRequested:
                state.destination = .confirm(Confirm.State())
                return .none

            case .destination(.presented(.confirm(.delegate(.confirmed)))):
                return .send(.confirmed)

            case .confirmed:
                return .run { send in
                    await send(.binding(.set(\.inputText, "123")))
                }

            case .binding(\.inputText):
                state.value = Int(state.inputText)
                return .none

            case .binding:
                return .none

            case .destination:
                return .none

            case .valueUpdated(let newValue):
                state.text = newValue != nil ? "\(newValue!)" : "???"
                return .none
                
            case .onAppear:
                let publisher = state.$value.publisher.map { Action.valueUpdated($0) }
                return .publisher { publisher }
                    .cancellable(id: CancelID.valuePublisher, cancelInFlight: true)

            case .onDisappear:
                return .cancel(id: CancelID.valuePublisher)
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    @Reducer(state: .equatable, action: .equatable)
    public enum Destination {
        case confirm(Confirm)
    }
}

@Reducer
public struct Confirm {
    @ObservableState
    public struct State: Equatable {}

    public enum Action: Equatable {
        case delegate(Delegate)

        @CasePathable
        public enum Delegate: Equatable {
            case confirmed
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            case .delegate:
                return .none
            }
        }
    }
}
