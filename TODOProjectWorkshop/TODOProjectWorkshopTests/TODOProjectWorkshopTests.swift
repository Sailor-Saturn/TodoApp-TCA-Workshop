//
//  TODOProjectWorkshopTests.swift
//  TODOProjectWorkshopTests
//
//  Created by Vera Dias on 03/05/2024.
//

import XCTest
import ComposableArchitecture
@testable import TODOProjectWorkshop
@MainActor
final class TODOProjectWorkshopTests: XCTestCase {
    let clock = TestClock()
    
    func testAddTodo() async {
        let store = TestStore(initialState: Todos.State()) {
            Todos()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addTodoButtonTapped) {
            $0.todos.insert(
                Todo.State(
                    description: "",
                    id: UUID(0),
                    isComplete: false
                ),
                at: 0
            )
        }
        
        await store.send(.addTodoButtonTapped) {
            $0.todos = [
                Todo.State(
                    description: "",
                    id: UUID(1),
                    isComplete: false
                ),
                Todo.State(
                    description: "",
                    id: UUID(0),
                    isComplete: false
                ),
            ]
        }
    }
    
    func testEditTodo() async {
        let state = Todos.State(
            todos: [
                Todo.State(
                    description: "",
                    id: UUID(0),
                    isComplete: false
                )
            ]
        )
        
        let store = TestStore(initialState: state) {
            Todos()
        }
        
        await store.send(
            .todos(
                .element(
                    id: state.todos[0].id, action: .set(\.description, "Learn Composable Architecture")
                )
            )
        ) {
            $0.todos[id: state.todos[0].id]?.description = "Learn Composable Architecture"
        }
    }
    
    func testCompleteTodo() async {
        let state = Todos.State(
            todos: [
                Todo.State(
                    description: "",
                    id: UUID(0),
                    isComplete: false
                ),
                Todo.State(
                    description: "",
                    id: UUID(1),
                    isComplete: false
                ),
            ]
        )
        
        let store = TestStore(initialState: state) {
            Todos()
        } withDependencies: {
            $0.continuousClock = self.clock
        }
        
        await store.send(.todos(.element(id: state.todos[0].id, action: .set(\.isComplete, true)))) {
            $0.todos[id: state.todos[0].id]?.isComplete = true
        }
    }
    
}
