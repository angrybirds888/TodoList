//
//  TodoDetailTableViewCell.swift
//  TodoList
//
//  Created by Aisha Madalieva on 05/11/25.
//

import UIKit

class TodoToggle: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        return label
    }()

    let toggleSwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .inline
        return picker
    }()

    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)

        let horizontalStack = UIStackView(arrangedSubviews: [titleLabel, toggleSwitch])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        horizontalStack.alignment = .center

        stackView.addArrangedSubview(horizontalStack)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        toggleSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func switchChanged() {
        if toggleSwitch.isOn {
            if !stackView.arrangedSubviews.contains(datePicker) {
                stackView.addArrangedSubview(datePicker)
            }
        } else {
            stackView.removeArrangedSubview(datePicker)
            datePicker.removeFromSuperview()
        }
    }
}
