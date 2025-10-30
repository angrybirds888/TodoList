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
        .init(name: "Call mom", isCompleted: true),
        .init(name: "Feed the cat"),
        .init(name: "Hit the gym"),
        .init(name: "Make dinner"),
        .init(name: "Brush teeth")
    ]

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "My tasks"
 
        view.backgroundColor = .white

        setupTableView()
        makeConstraints()
    }

    func setupTableView() {
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "my cell")
        tableView.register(TodoListHeaderView.self, forHeaderFooterViewReuseIdentifier: "my header")
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension TodoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "my cell", for: indexPath) as! TodoItemTableViewCell
        cell.configure(todoItems[indexPath.row].name, isCompleted: todoItems[indexPath.row].isCompleted)
        return cell
    }
}


extension TodoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "my header") as! TodoListHeaderView
        return view
    }
}
