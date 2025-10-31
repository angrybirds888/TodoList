//
//  TodoDetailViewController.swift
//  TodoList
//
//  Created by Oisha Sh. Madalieva on 31/10/25.
//

import UIKit

class TodoDetailViewController: UIViewController {

    let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        addSubviews()
        setupUI()
        makeConstraints()
    }

    func addSubviews() {
        view.addSubview(textView)
    }

    func setupUI() {
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.text = "Enter text here..."
        textView.isScrollEnabled = true

        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func makeConstraints() {
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.height.equalTo(100)
        }
    }
}
