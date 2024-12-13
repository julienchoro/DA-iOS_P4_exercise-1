import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties
    
    private var index = 0

    private let repository: ToDoListRepositoryType

    // MARK: - Init

        init(repository: ToDoListRepositoryType) {
            self.repository = repository
            self.toDoItems = repository.loadToDoItems()
            self.filteredTasks = [ToDoItem]()
            applyFilter(at: 0)
        }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }

    // Publisher for the filteredTasks propertie to make SwiftUI observe any changement in it.
    @Published var filteredTasks: [ToDoItem]

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        toDoItems.append(item)
        applyFilter(at: index)
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].isDone.toggle()
        }
        applyFilter(at: index)
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        toDoItems.removeAll { $0.id == item.id }
        applyFilter(at: index)
    }

    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        self.index = index
        switch index {
        case 0:
            self.filteredTasks = self.toDoItems
        case 1:
            self.filteredTasks = self.toDoItems.filter { $0.isDone }
        case 2:
            self.filteredTasks = self.toDoItems.filter { !$0.isDone }
        default:
            self.filteredTasks = self.toDoItems
        }
    }
}
