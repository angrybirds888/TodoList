//
//  TodoDetailViewController.swift
//  TodoList
//
//  Created by Oisha Sh. Madalieva on 31/10/25.
//

import UIKit

final class TodoDetailViewController: UIViewController {

    // MARK: - UI
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: "text view cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        makeConstraints()
    }

    func configureNavigationBar() {
        navigationItem.title = "Todo"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        view.backgroundColor = .systemGroupedBackground
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc func saveButtonTapped() {
        // TODO: Save task
    }
}


extension TodoDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "text view cell", for: indexPath) as! TextViewTableViewCell
        cell.selectionStyle = .none
        return cell
    }
}

extension TodoDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
