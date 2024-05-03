//
//  ContentView.swift
//  TODOProjectWorkshop
//
//  Created by Vera Dias on 03/05/2024.
//

import SwiftUI
import ComposableArchitecture

struct TodoView: View {
    @Bindable var store: StoreOf<Todo>

    var body: some View {
      HStack {
        Button {
          store.isComplete.toggle()
        } label: {
          Image(systemName: store.isComplete ? "checkmark.square" : "square")
        }
        .buttonStyle(.plain)

        TextField("Untitled Todo", text: $store.description)
      }
      .foregroundColor(store.isComplete ? .gray : nil)
    }
}


@Reducer
struct Todo {
    @ObservableState
    struct State: Equatable, Identifiable {
        var description = ""
        let id: UUID
        var isComplete = false
    }
    
    enum Action: BindableAction, Sendable {
      case binding(BindingAction<State>)
    }

    var body: some Reducer<State, Action> {
      BindingReducer()
    }
}

#Preview {
    TodoView(store: .init(initialState: Todo.State(
        description: "Check Mail",
        id: UUID(),
        isComplete: false
    ), reducer: {
        Todo()
    }))
}
