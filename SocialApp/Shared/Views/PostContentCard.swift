//
//  PostContentCard.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import SnapKit
import UIKit

struct PostHeaderConfig {
    let contentLines: Int
}

class PostContentCard: UIView {
    private lazy var iconView = UIImageView() ~!~ {
        $0.backgroundColor = .red
        $0.snp.makeConstraints {
            $0.size.equalTo(32)
        }
    }
    private lazy var ownerLbl = UILabel() ~!~ {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.black
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    private lazy var dateLbl = UILabel() ~!~ {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor.gray
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    private lazy var contentLbl = UILabel() ~!~ {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor.black
        $0.textAlignment = .left
        $0.numberOfLines = config.contentLines
    }

    private lazy var stackView = VStack {
        HStack {
            iconView
            VStack {
                ownerLbl
                dateLbl
            }
            .setSpacing(2)
            .setDistribution(.fill)
        }
        .setSpacing(4)
        .setAlignment(.center)
        .setDistribution(.fill)
        contentLbl
    }
    .setSpacing(8)
    .setDistribution(.fill)

    let config: PostHeaderConfig

    init(config: PostHeaderConfig) {
        self.config = config
        super.init(frame: .zero)
        setupUI()
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
                .inset(8)
        }
    }

    func configure(ownerName: String, date: String, content: String) {
        self.ownerLbl.text = ownerName
        self.dateLbl.text = date.convertDate(toFormat: .normal)
        self.contentLbl.text = content
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
