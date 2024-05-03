import ComposableArchitecture
import SwiftUI

@Reducer
struct Todos {
    @ObservableState
    struct State: Equatable {
        var editMode: EditMode = .inactive
        var todos: IdentifiedArrayOf<Todo.State> = []
    }
    
    enum Action: BindableAction, Sendable {
        case addTodoButtonTapped
        case binding(BindingAction<State>)
        case todos(IdentifiedActionOf<Todo>)
        case delete(IndexSet)
        case clearCompletedButtonTapped
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case todoCompletion }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addTodoButtonTapped:
                state.todos.insert(Todo.State(id: self.uuid()), at: 0)
                return .none
                
            case .binding:
                return .none
                
            case let .delete(indexSet):
                for index in indexSet {
                    state.todos.remove(id: state.todos[index].id)
                }
                return .none
                
            case .todos:
                return .none

            case .clearCompletedButtonTapped:
              state.todos.removeAll(where: \.isComplete)
              return .none
            }
        }
        .forEach(\.todos, action: \.todos) {
            Todo()
        }
    }
}

struct AppView: View {
    @Bindable var store: StoreOf<Todos>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                List {
                    ForEach(store.scope(state: \.todos, action: \.todos)) { store in
                        TodoView(store: store)
                    }
                    .onDelete { store.send(.delete($0)) }
                }
            }
            .navigationTitle("Todos")
            .navigationBarItems(
                leading: HStack(spacing: 20) {
                    Button("Clear Completed") {
                      store.send(.clearCompletedButtonTapped, animation: .default)
                    }
                    .disabled(!store.todos.contains(where: \.isComplete))
                    
                }, trailing: HStack(spacing: 20) {
                    Button("Add Todo") { store.send(.addTodoButtonTapped, animation: .default) }
                }
            )
            .environment(\.editMode, $store.editMode)
        }
    }
}


extension IdentifiedArray where ID == Todo.State.ID, Element == Todo.State {
  static let mock: Self = [
    Todo.State(
      description: "Check Mail",
      id: UUID(),
      isComplete: false
    ),
    Todo.State(
      description: "Buy Milk",
      id: UUID(),
      isComplete: false
    ),
    Todo.State(
      description: "Call Mom",
      id: UUID(),
      isComplete: true
    ),
  ]
}

#Preview {
  AppView(
    store: Store(initialState: Todos.State(todos: .mock)) {
      Todos()
    }
  )
}
