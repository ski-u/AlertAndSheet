import ComposableArchitecture
import SwiftUI

@Reducer
struct SecondSheet {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case closeButtonTapped
        case delegate(Delegate)
        
        @CasePathable
        enum Alert {
            case closeButtonTapped
        }
        
        @CasePathable
        enum Delegate {
            case dismissed
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.closeButtonTapped)):
                return .send(.delegate(.dismissed))
                
            case .alert:
                return .none
                
            case .closeButtonTapped:
                state.alert = .closeConfirmation()
                return .none
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension AlertState where Action == SecondSheet.Action.Alert {
    static func closeConfirmation() -> Self {
        .init {
            .init("Are you sure?")
        } actions: {
            ButtonState(action: .closeButtonTapped) {
                .init("OK")
            }
            ButtonState(role: .cancel) {
                .init("Cancel")
            }
        }
    }
}

struct SecondSheetView: View {
    @Bindable var store: StoreOf<SecondSheet>
    
    var body: some View {
        NavigationStack {
            Button(action: { store.send(.closeButtonTapped) }) {
                Text("Close")
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            .navigationTitle(.init("Second Sheet"))
        }
    }
}
