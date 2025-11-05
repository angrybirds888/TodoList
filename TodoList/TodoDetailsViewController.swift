//
//  TodoDetailsViewController.swift
//  TodoList
//
//  Created by Aisha Madalieva on 05/11/25.
//

import UIKit

class TodoDetailsViewController: UIViewController {

    // MARK: - Properties
    var todoItem: TodoItem?

    let placeholderText = "Something needs to be done..."

    // MARK: - UI
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        return scroll
    }()

    let contentView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.cornerRadius = 16

        if let item = todoItem {
            textView.text = item.name
            textView.textColor = .black
        } else {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
        textView.delegate = self
        return textView
    }()

    let importanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Importance"
        return label
    }()

    let toggleView: TodoToggle = {
        let view = TodoToggle()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(textView)
        contentView.addSubview(toggleView)
        contentView.addSubview(importanceView)
        contentView.addSubview(deleteButton)

        importanceView.addSubview(titleLabel)

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
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        textView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        importanceView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(16)
        }

        toggleView.snp.makeConstraints { make in
            make.top.equalTo(importanceView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(toggleView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc func saveButtonTapped() {
        // TODO: Save task
        dismiss(animated: true)
    }
}

extension TodoDetailsViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}
