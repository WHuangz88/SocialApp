//
//  PostCell.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit

class PostCell: UITableViewCell {

    private lazy var separator = LineSeparator()
    private lazy var card = PostContentCard(config: .init(contentLines: 2))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubviews(separator, card)
        setupConstraint()
    }

    func bindData(ownerName: String, date: String, content: String) {
        self.card.configure(ownerName: ownerName, date: date, content: content)
    }

    private func setupConstraint() {
        separator.snp.makeConstraints {
            $0.top.equalTo(card.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        card.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

