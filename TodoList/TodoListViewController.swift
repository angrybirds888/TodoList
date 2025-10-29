//
//  ViewController.swift
//  TodoList
//
//  Created by Oisha Sh. Madalieva on 27/10/25.
//

import UIKit
import SnapKit

class TodoListViewController: UIViewController, UITableViewDataSource {

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
        tableView.dataSource = self

        view.addSubview(tableView)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "my cell", for: indexPath) as! TodoItemTableViewCell
        return cell
    }
}
