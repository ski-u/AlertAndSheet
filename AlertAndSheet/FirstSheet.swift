import ComposableArchitecture
import SwiftUI

@Reducer
struct FirstSheet {
    @Reducer(state: .equatable)
    enum Destination {
        case secondSheet(SecondSheet)
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case openSecondSheetViewButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(.presented(.secondSheet(.delegate(.dismissed)))):
                state.destination = nil
                return .none
                
            case .destination:
                return .none
                
            case .openSecondSheetViewButtonTapped:
                state.destination = .secondSheet(.init())
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

struct FirstSheetView: View {
    @Bindable var store: StoreOf<FirstSheet>
    
    var body: some View {
        NavigationStack {
            Button(action: { store.send(.openSecondSheetViewButtonTapped) }) {
                Text("Open second sheet view")
            }
            .sheet(
                item: $store.scope(state: \.destination?.secondSheet, action: \.destination.secondSheet)
            ) { store in
                SecondSheetView(store: store)
            }
            .navigationTitle(.init("First Sheet"))
        }
    }
}
