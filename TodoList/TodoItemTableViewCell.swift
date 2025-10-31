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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(circleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
        
        setupUI()
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        circleImageView.tintColor = .tertiaryLabel
        circleImageView.contentMode = .scaleAspectFit
        
        chevronImageView.tintColor = .tertiaryLabel
        chevronImageView.contentMode = .scaleAspectFit
    }
    
    func configure(_ title: String, isCompleted: Bool) {
        if isCompleted {
            circleImageView.image = UIImage(systemName: "checkmark.circle.fill")
            circleImageView.tintColor = UIColor(named: "successColor")
            
            titleLabel.textColor = .tertiaryLabel
            
            let attributeString = NSMutableAttributedString(string: title)
            attributeString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: title.count)
            )
            titleLabel.attributedText = attributeString
            
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
        }
        
        chevronImageView.snp.updateConstraints { make in
            make.verticalEdges.trailing.equalToSuperview().inset(16)
        }
        super.updateConstraints()
    }
}
