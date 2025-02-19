import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties
    private var index = 0
    
    private let repository: ToDoListRepositoryType
    
    // MARK: - Init
    
    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.toDoItems = repository.loadToDoItems()
        self.toDoItems = allToDos
        applyFilter(at: 0)
    }
    
    // MARK: - Utils
    private func update() {
        repository.saveToDoItems(allToDos)
        applyFilter(at: index)
    }
    
    // MARK: - Outputs
    
    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = []
    
    @Published var allToDos: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(allToDos)
        }
    }
    
    // MARK: - Inputs
    
    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        allToDos.append(item)
        applyFilter(at: index)
    }
    
    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let allTodosIndex = allToDos.firstIndex(where: { $0.id == item.id }) {
            allToDos[allTodosIndex].isDone.toggle()
            applyFilter(at: self.index)
        }
    }
    
    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        allToDos.removeAll { $0.id == item.id }
        applyFilter(at: index)
    }
    
    /// Apply the filter to update the list.
    func applyFilter(at newIndex: Int) {
        index = newIndex
        
        switch index {
        case 0:
            self.toDoItems = self.allToDos
        case 1:
            self.toDoItems = self.allToDos.filter { $0.isDone }
        case 2:
            self.toDoItems = self.allToDos.filter { !$0.isDone }
        default:
            self.toDoItems = self.allToDos
        }
    }
}
