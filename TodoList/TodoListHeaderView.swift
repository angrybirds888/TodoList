//
//  TodoListHeaderView.swift
//  TodoList
//
//  Created by Oisha Sh. Madalieva on 29/10/25.
//

import UIKit

class TodoListHeaderView: UITableViewHeaderFooterView {

    let taskName = UILabel()
    let showButton = UIButton()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(taskName)
        contentView.addSubview(showButton)
    
        setupUI()

        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        taskName.text = "Tasks - 4"
        taskName.textColor = .lightGray

        showButton.setTitle("Show", for: .normal)
        showButton.setTitleColor(.blue, for: .normal)
    }

    override func updateConstraints() {
        taskName.snp.updateConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        showButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        super.updateConstraints()
    }
}
