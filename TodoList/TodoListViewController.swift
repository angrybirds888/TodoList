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
        let tableView = UITableView()
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

        makeConstraints()

        let addButton = UIBarButtonItem(customView: addButton)

        toolbarItems = [UIBarButtonItem(systemItem: .flexibleSpace), addButton, UIBarButtonItem(systemItem: .flexibleSpace)]
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

        cell.onToggleCompletion = { [weak self] in
            guard let self else { return }
            item.isCompleted.toggle()
            todoItems[indexPath.row] = item

            tableView.reloadRows(at: [indexPath], with: .automatic)
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
        presentDetailScreen(todoItems[indexPath.item])
    }
}
