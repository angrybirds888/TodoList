//
//  TextViewTableViewCell.swift
//  TodoList
//
//  Created by Aisha Madalieva on 03/11/25.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {

    // MARK: - Properties
    let placeholderText = "Something needs to be done..."

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.textContainerInset = .zero
        textView.text = placeholderText
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        textView.layer.cornerRadius = 11
        textView.textColor = .lightGray
        textView.delegate = self
        return textView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        contentView.backgroundColor = .systemGroupedBackground
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        textView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
        super.updateConstraints()
    }
}


extension TextViewTableViewCell: UITextViewDelegate {

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
