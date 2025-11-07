//
//  ViewController.swift
//  TodoList
//
//  Created by Oisha Sh. Madalieva on 27/10/25.
//

import UIKit
import SnapKit

class TodoListViewController: UIViewController {

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

extension TodoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "my cell", for: indexPath) as! TodoItemTableViewCell

        var item = todoItems[indexPath.row]

        cell.selectionStyle = .none
        cell.configure(item.name, isCompleted: item.isCompleted)

        cell.onToggleCompletion = { [weak self, weak cell] in
            guard let self = self, let cell = cell, let currentIndexPath = tableView.indexPath(for: cell) else { return }
            self.todoItems[currentIndexPath.row].isCompleted.toggle()
            tableView.reloadRows(at: [currentIndexPath], with: .automatic)
            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        return cell
    }
}

extension TodoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "my header") as! TodoListHeaderView
        view.updateTaskCount(todoItems.count)
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !todoItems[indexPath.item].isCompleted {
            presentDetailScreen(todoItems[indexPath.item])
        }
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markAsCompleted = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            guard let self = self else { completion(false); return }

            self.todoItems[indexPath.row].isCompleted = true

            let movedItem = self.todoItems.remove(at: indexPath.row)
            self.todoItems.insert(movedItem, at: 0)

            let destinationIndexPath = IndexPath(row: 0, section: indexPath.section)

            self.tableView.performBatchUpdates {
                self.tableView.moveRow(at: indexPath, to: destinationIndexPath)
            } completion: { _ in
                if let cell = self.tableView.cellForRow(at: destinationIndexPath) {
                    cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    UIView.animate(withDuration: 0.35,
                                   delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 0.8,
                                   options: .curveEaseOut,
                                   animations: {
                        cell.transform = .identity
                    }, completion: nil)
                }
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
            completion(true)
        }

        markAsCompleted.image = UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
        markAsCompleted.backgroundColor = .success
        return UISwipeActionsConfiguration(actions: [markAsCompleted])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            guard let self = self else { completion(false); return }

            self.todoItems.remove(at: indexPath.row)
            self.tableView.performBatchUpdates {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } completion: { _ in
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
            completion(true)
        }
        trash.image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
        trash.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [trash])
    }
}
