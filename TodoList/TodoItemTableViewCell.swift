//
//  TodoItemTableViewCell.swift
//  TodoList
//
//  Created by Oisha Sh. Madalieva on 27/10/25.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {

    let circleImageView = UIImageView(image: UIImage(systemName: "circle"))
    let titleLabel = UILabel()
    let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

    var onToggleCompletion: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(circleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)

        setupUI()
        setupTap()

        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        circleImageView.tintColor = .tertiaryLabel
        circleImageView.contentMode = .scaleAspectFit

        chevronImageView.tintColor = .tertiaryLabel
        chevronImageView.contentMode = .scaleAspectFit
    }

    private func setupTap() {
        circleImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(circleTapped))
        circleImageView.addGestureRecognizer(tap)
    }

    @objc private func circleTapped() {
        onToggleCompletion?()
    }

    func configure(_ title: String, isCompleted: Bool) {
        if isCompleted {
            circleImageView.image = UIImage(systemName: "checkmark.circle.fill")
            circleImageView.tintColor = UIColor(named: "successColor")

            titleLabel.textColor = .tertiaryLabel

            let attr = NSMutableAttributedString(string: title)
            attr.addAttribute(.strikethroughStyle,
                              value: NSUnderlineStyle.single.rawValue,
                              range: NSMakeRange(0, title.count))
            titleLabel.attributedText = attr
        } else {
            circleImageView.image = UIImage(systemName: "circle")
            circleImageView.tintColor = .tertiaryLabel

            titleLabel.textColor = .label
            titleLabel.attributedText = NSAttributedString(string: title)
        }
    }

    override func updateConstraints() {
        circleImageView.snp.updateConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(16)
            make.size.equalTo(22)
        }

        titleLabel.snp.updateConstraints { make in
            make.leading.equalTo(circleImageView.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-8)
        }

        chevronImageView.snp.updateConstraints { make in
            make.verticalEdges.trailing.equalToSuperview().inset(16)
        }
        super.updateConstraints()
    }
}
