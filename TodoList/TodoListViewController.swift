//
//  ViewController.swift
//  TodoList
//
//  Created by Oisha Sh. Madalieva on 27/10/25.
//

import UIKit
import SnapKit
import CoreData

class TodoListViewController: UIViewController {

    let context: NSManagedObjectContext
    var todos: [TodoItemEntity] = []

    var todoItems: [TodoItem] = [
        .init(name: "Call mom"),
        .init(name: "Feed the cat"),
        .init(name: "Hit the gym"),
        .init(name: "Make dinner"),
        .init(name: "Brush teeth")
    ]

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TodoListHeaderView.self, forHeaderFooterViewReuseIdentifier: "my header")
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "my cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        return tableView
    }()

    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 36/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        navigationItem.title = "My tasks"

        let addButton = UIBarButtonItem(customView: addButton)

        toolbarItems = [UIBarButtonItem(systemItem: .flexibleSpace), addButton, UIBarButtonItem(systemItem: .flexibleSpace)]

        makeConstraints()
        loadTodos()
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addButton.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
    }

    @objc func addTapped() {
        presentDetailScreen()
    }

    func loadTodos() {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        context.perform {
            do {
                let fetched = try self.context.fetch(request)
                DispatchQueue.main.async {
                    if fetched.isEmpty {
                        self.setInitialTodosIfNeeded()
                    } else {
                        self.todos = fetched
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Fetch error: \(error)")
            }
        }
    }

    func setInitialTodosIfNeeded() {
        context.perform {
            for sample in self.todoItems {
                let entity = TodoItemEntity(context: self.context)
                entity.name = sample.name
                entity.isCompleted = sample.isCompleted
            }
            do {
                try self.context.save()
            } catch {
                print("Seed save error: \(error)")
            }
            self.loadTodos()
        }
    }

    func addTodo(from item: TodoItem) {
        context.perform {
            let entity = TodoItemEntity(context: self.context)
            entity.name = item.name
            entity.isCompleted = item.isCompleted

            do {
                try self.context.save()
                
                let req: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
                
                let fetched = try self.context.fetch(req)
                DispatchQueue.main.async {
                    self.todos = fetched
                    self.tableView.reloadData()
                }
            } catch {
                print("Add save error: \(error)")
            }
        }
    }

    func toggleCompletion(at index: Int) {
        let entity = todos[index]
        context.perform {
            entity.isCompleted.toggle()
            do {
                try self.context.save()
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                }
            } catch {
                print("Toggle save error: \(error)")
            }
        }
    }

    func markAsCompletedAndMoveToTop(at index: Int) {
        context.perform {
            let entity = self.todos[index]
            entity.isCompleted = true
            do {
                try self.context.save()
                
                let req: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
                let fetched = try self.context.fetch(req)
                
                DispatchQueue.main.async {
                    self.todos = fetched
                    self.tableView.reloadData()
                }
            } catch {
                print("Mark completed save error: \(error)")
            }
        }
    }

    func deleteTodo(at index: Int) {
        let entity = todos[index]
        context.perform {
            self.context.delete(entity)
            do {
                try self.context.save()
                DispatchQueue.main.async {
                    self.todos.remove(at: index)
                    self.tableView.performBatchUpdates {
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    } completion: { _ in
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                    }
                }
            } catch {
                print("Delete save error: \(error)")
            }
        }
    }

    func presentDetailScreen(_ item: TodoItem? = nil) {
        let vc = TodoDetailsViewController()
        vc.todoItem = item
        vc.onFinish = { newItem in
            self.todoItems.append(newItem)
            self.tableView.reloadData()
        }
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "my cell", for: indexPath) as! TodoItemTableViewCell
        let entity = todos[indexPath.row]

        cell.selectionStyle = .none
        cell.configure(entity.name ?? "", isCompleted: entity.isCompleted)

        cell.onToggleCompletion = { [weak self, weak cell] in
            guard let self = self, let cell = cell, let currentIndexPath = tableView.indexPath(for: cell) else { return }
            self.toggleCompletion(at: currentIndexPath.row)
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "my header") as! TodoListHeaderView
        view.updateTaskCount(todos.count)
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !todos[indexPath.item].isCompleted {
            let entity = todos[indexPath.item]
            let item = TodoItem(name: entity.name ?? "", isCompleted: entity.isCompleted)
            presentDetailScreen(item)
        }
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markAsCompleted = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            guard let self = self else { completion(false); return }
            self.markAsCompletedAndMoveToTop(at: indexPath.row)
            completion(true)
        }

        markAsCompleted.image = UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
        markAsCompleted.backgroundColor = .success
        return UISwipeActionsConfiguration(actions: [markAsCompleted])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self = self else { completion(false); return }
            self.deleteTodo(at: indexPath.row)
            completion(true)
        }
        trash.image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [trash])
    }
}
