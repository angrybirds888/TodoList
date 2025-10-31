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
    let addButton = UIButton(type: .system)


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        navigationItem.title = "My tasks"
 
        view.backgroundColor = .systemBackground

        setupTableView()
        setupAddButton()
        makeConstraints()

        let addButton = UIBarButtonItem(customView: addButton)

        toolbarItems = [UIBarButtonItem(systemItem: .flexibleSpace), addButton, UIBarButtonItem(systemItem: .flexibleSpace)]
    }

    func setupAddButton() {
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .white
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 36/2
        addButton.clipsToBounds = true
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    func setupTableView() {
        tableView.register(TodoListHeaderView.self, forHeaderFooterViewReuseIdentifier: "my header")
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "my cell")
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
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
        let viewController = TodoDetailViewController()

        navigationController?.present(viewController, animated: true)
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
        view.updateTaskCount(todoItems.count)
        return view
    }
}
